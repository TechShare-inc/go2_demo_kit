import gi
gi.require_version('Gst', '1.0')
from gi.repository import Gst, GLib
import numpy as np
import rclpy
from rclpy.node import Node
from sensor_msgs.msg import Image
from cv_bridge import CvBridge

class VideoPublisher(Node):
    def __init__(self):
        super().__init__('video_publisher')
        self.publisher_ = self.create_publisher(Image, 'video_frames', 10)
        self.bridge = CvBridge()

        # Initialize GStreamer
        Gst.init(None)
        self.frames = []

        # Define the GStreamer pipeline string
        pipeline_str = (
            "udpsrc address=230.1.1.1 port=1720 multicast-iface=eth0 ! "
            "queue ! application/x-rtp, media=video, encoding-name=H264 ! "
            "rtph264depay ! h264parse ! nvv4l2decoder ! nvvidconv ! video/x-raw,format=BGRx ! appsink name=appsink0"
        )

        # Create the pipeline
        self.pipeline = Gst.parse_launch(pipeline_str)

        # Get the appsink element
        self.appsink = self.pipeline.get_by_name("appsink0")
        self.appsink.set_property("emit-signals", True)
        self.appsink.set_property("sync", False)

        # Connect the callback
        self.appsink.connect("new-sample", self.on_new_sample)

        # Start playing the pipeline
        self.pipeline.set_state(Gst.State.PLAYING)

        # Wait until error or EOS (End of Stream)
        self.bus = self.pipeline.get_bus()
        self.bus.add_signal_watch()
        self.loop = GLib.MainLoop()
        self.bus.connect("message", self.on_message)

        self.get_logger().info('VideoPublisher node has been started.')

    def on_new_sample(self, sink):
        sample = sink.emit("pull-sample")
        buf = sample.get_buffer()
        caps = sample.get_caps()
        height = caps.get_structure(0).get_value("height")
        width = caps.get_structure(0).get_value("width")

        # Extract buffer data
        success, map_info = buf.map(Gst.MapFlags.READ)
        if not success:
            return Gst.FlowReturn.ERROR

        try:
            array = np.frombuffer(map_info.data, dtype=np.uint8).reshape((height, width, 4))
            array = array[:, :, :3]  # Convert BGRx to BGR

            # Convert numpy array to ROS Image message
            image_message = self.bridge.cv2_to_imgmsg(array, encoding="bgr8")
            self.publisher_.publish(image_message)
        finally:
            buf.unmap(map_info)

        return Gst.FlowReturn.OK

    def on_message(self, bus, message):
        if message.type == Gst.MessageType.EOS:
            self.get_logger().info("End-Of-Stream reached")
            self.loop.quit()
        elif message.type == Gst.MessageType.ERROR:
            err, debug = message.parse_error()
            self.get_logger().error(f"Error received from element {message.src.get_name()}: {err}")
            self.get_logger().error(f"Debugging information: {debug}")
            self.loop.quit()

    def run(self):
        try:
            self.get_logger().info("Running...")
            self.loop.run()
        except KeyboardInterrupt:
            self.get_logger().info("Interrupted by user, stopping...")
        finally:
            # Free resources
            self.pipeline.set_state(Gst.State.NULL)

def main(args=None):
    rclpy.init(args=args)
    node = VideoPublisher()
    node.run()
    rclpy.shutdown()

if __name__ == '__main__':
    main()