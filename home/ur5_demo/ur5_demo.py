import IPython
from ur5_factory import UR5_Factory
ur5_factory = UR5_Factory()

# If you want to specify all the configuration settings (is_simulation, has_ridgeback etc)
env, robot = ur5_factory.create_ur5_and_env(is_simulation=True,
                                            has_ridgeback=True,
                                            gripper_name="robotiq_two_finger",
                                            has_force_torque_sensor=False,
                                            env_path="test_env.xml",
                                            viewer_name="qtcoin",
                                            urdf_path="package://ur5controller/ur5_description/urdf/",
                                            srdf_path="package://ur5controller/ur5_description/srdf/")

IPython.embed()
