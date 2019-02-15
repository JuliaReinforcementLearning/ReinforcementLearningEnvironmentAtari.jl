using ReinforcementLearningEnvironmentAtari, Test, ReinforcementLearningBase

test_envinterface(AtariEnv("pong"))

env = AtariEnv("pong", frame_skip = 10000)
@test ReinforcementLearningEnvironmentAtari.interact!(env, 1).isdone == true
env = AtariEnv("pong", frame_skip = 1)
@test ReinforcementLearningEnvironmentAtari.interact!(env, 1).isdone == false
