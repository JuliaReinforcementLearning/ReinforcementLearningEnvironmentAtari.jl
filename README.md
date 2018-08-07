# RLEnvAtari

[![Build Status](https://travis-ci.org/JuliaReinforcementLearning/RLEnvAtari.jl.svg?branch=master)](https://travis-ci.org/JuliaReinforcementLearning/RLEnvAtari.jl)

[![Coverage Status](https://coveralls.io/repos/JuliaReinforcementLearning/RLEnvAtari.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/JuliaReinforcementLearning/RLEnvAtari.jl?branch=master)

[![codecov.io](http://codecov.io/github/JuliaReinforcementLearning/RLEnvAtari.jl/coverage.svg?branch=master)](http://codecov.io/github/JuliaReinforcementLearning/RLEnvAtari.jl?branch=master)

Makes the [ArcadeLearningEnvironment](https://github.com/JuliaReinforcementLearning/ArcadeLearningEnvironment.jl) available as an environment for the [Julia Reinforcement Learning package](https://github.com/JuliaReinforcementLearning/ReinforcementLearning.jl).

## Usage

```julia
using RLEnvAtari

?AtariEnv
environment = AtariEnv("breakout")
preprocessor = AtariPreprocessor()
```

See also [examples](examples).


