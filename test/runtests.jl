using ReinforcementLearningEnvironmentAtari
using Test

import ReinforcementLearningEnvironmentAtari: reset!, interact!, getstate
env = AtariEnv("pong")
reset!(env)
@test typeof(interact!(env, 1)) == NamedTuple{(:observation, :reward, :isdone), Tuple{Array{UInt8, 1}, Int32, Bool}}
@test typeof(getstate(env)) == NamedTuple{(:observation, :isdone), Tuple{Array{UInt8, 1}, Bool}}
