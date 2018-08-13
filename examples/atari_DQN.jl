using RLEnvAtari, Flux, GR, JLD2
import ArcadeLearningEnvironment: getMinimalActionSet, getLegalActionSet
const withgpu = false
if withgpu 
    using CuArrays
    const inputdtype = Float32
else
    const inputdtype = Float64
end
env = AtariEnv("breakout")
model = Chain(x -> x./inputdtype(255), Conv((8, 8), 4 => 32, relu, stride = (4, 4)), 
                         Conv((4, 4), 32 => 64, relu, stride = (2, 2)),
                         Conv((3, 3), 64 => 64, relu),
                         x -> reshape(x, :, size(x, 4)),
                         Dense(3136, 512, relu), 
                         Dense(512, length(env.actions)));
learner = DQN(model, opttype = x -> Flux.RMSProp(x, .00025, ρ = .95, ϵ = .01), 
              loss = huberloss,
              updatetargetevery = 10^4, replaysize = 10^6, nmarkov = 4,
              startlearningat = 50000);
x = RLSetup(learner, 
            env,
            ConstantNumberSteps(2000),
            preprocessor = AtariPreprocessor(gpu=withgpu, outdim = (84, 84)),
            callbacks = [Visualize(wait = 0)])
GR.inline("mov")
beginprint("before.mov")
run!(x)
endprint()
x.callbacks = [Progress(5*10^2), EvaluationPerEpisode(TotalReward()),
               LinearDecreaseEpsilon(5 * 10^4, 10^6, 1, .1)];
x.stoppingcriterion = ConstantNumberSteps(4 * 10^6)
@time learn!(x)
@save "model.jld2" model
x.callbacks = [Visualize(wait = 0)]
x.stoppingcriterion = ConstantNumberSteps(2000)
beginprint("after.mov")
run!(x)
endprint()
