# RLEnvAtari

[![Build Status](https://travis-ci.org/jbrea/RLEnvAtari.jl.svg?branch=master)](https://travis-ci.org/jbrea/RLEnvAtari.jl)

[![Coverage Status](https://coveralls.io/repos/jbrea/RLEnvAtari.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/jbrea/RLEnvAtari.jl?branch=master)

[![codecov.io](http://codecov.io/github/jbrea/RLEnvAtari.jl/coverage.svg?branch=master)](http://codecov.io/github/jbrea/RLEnvAtari.jl?branch=master)

Makes the [ArcadeLearningEnvironment](https://github.com/jbrea/ArcadeLearningEnvironment.jl) available as an environment for the [Julia Reinforcement Learning package](https://github.com/jbrea/ReinforcementLearning.jl).

## Usage

```julia
using RLEnvAtari

?AtariEnv
environment = AtariEnv("breakout")
preprocessor = AtariPreprocessor()
```

See also [examples](examples).


