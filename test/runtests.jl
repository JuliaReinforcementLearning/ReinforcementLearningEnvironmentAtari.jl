using RLEnvAtari
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

import RLEnvAtari: reset!, interact!, getstate
env = AtariEnv("pong")
reset!(env)
@test typeof(interact!(1, env)) == Tuple{Array{UInt8, 1}, Int32, Bool}
@test typeof(getstate(env)) == Tuple{Array{UInt8, 1}, Bool}
