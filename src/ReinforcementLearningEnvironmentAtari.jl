__precompile__()
module ReinforcementLearningEnvironmentAtari
using ArcadeLearningEnvironment, Parameters, Reexport, GR, Compat
import Compat: Nothing
import ArcadeLearningEnvironment: getScreen
@reexport using ReinforcementLearning
import ReinforcementLearning: interact!, getstate, reset!, preprocessstate,
plotenv 

"""
    AtariEnv
            ale::Ptr{Nothing}
        screen::Array{UInt8, 1}
        getscreen::Function
        noopmax::Int64
"""
struct AtariEnv
    ale::Ptr{Nothing}
    screen::Array{UInt8, 1}
    getscreen::Function
    actions::Array{Int32, 1}
    noopmax::Int64
end
export AtariEnv
"""
    AtariEnv(name; colorspace = "Grayscale", frame_skip = 4, noopmax = 20,
                   color_averaging = true, repeat_action_probability = 0.)

Returns an AtariEnv that can be used in an RLSetup of the
[ReinforcementLearning](https://github.com/jbrea/ReinforcementLearning.jl)
package. Check the deps/roms folder of the ArcadeLearningEnvironment package to
see all available `name`s.
"""
function AtariEnv(name; 
                  colorspace = "Grayscale",
                  frame_skip = 4, noopmax = 20,
                  color_averaging = true,
                  actionset = :minimal,
                  repeat_action_probability = 0.)
    ale = ALE_new()
    loadROM(ale, name)
    setBool(ale, "color_averaging", color_averaging)
    setInt(ale, "frame_skip", Int32(frame_skip))
    setFloat(ale, "repeat_action_probability", 
             Float32(repeat_action_probability))
    if colorspace == "Grayscale"
        screen = Array{Cuchar}(undef, 210*160)
        getscreen = getScreenGrayscale
    elseif colorspace == "RGB"
        screen = Array{Cuchar}(undef, 3*210*160)
        getscreen = getScreenRGB
    elseif colorspace == "Raw"
        screen = Array{Cuchar}(undef, 210*160)
        getscreen = getScreen
    end
    AtariEnv(ale, screen, getscreen, 
             actionset == :minimal ? getMinimalActionSet(ale) : 
                                     getLegalActionSet(ale),
             noopmax)
end

function getScreen(p::Ptr, s::Array{Cuchar, 1})
    sraw = getScreen(p)
    for i in 1:length(s)
        s[i] =  sraw[i] .>> 1
    end
end

function interact!(a, env::AtariEnv)
    r = act(env.ale, env.actions[a])
    env.getscreen(env.ale, env.screen)
    env.screen, r, game_over(env.ale)
end
function getstate(env::AtariEnv)
    env.getscreen(env.ale, env.screen)
    env.screen, game_over(env.ale)
end
function reset!(env::AtariEnv)
    reset_game(env.ale)
    for _ in 1:rand(0:env.noopmax) act(env.ale, Int32(0)) end
    env.getscreen(env.ale, env.screen)
    env.screen
end

"""
AtariPreprocessor(; gpu = false, croptosquare = false,
                    cropfromrow = 34, color = false,
                    outdim = (80, croptosquare ? 80 : 105))
"""
function AtariPreprocessor(; gpu = false, croptosquare = false,
                             cropfromrow = 34, color = false,
                             outdim = (80, croptosquare ? 80 : 105))
    chain = []
    if croptosquare
        push!(chain, ImageCrop(1:160, cropfromrow:cropfromrow + 159))
    end
    if !((croptosquare && outdim == (160, 160)) || outdim == (160, 210))
        push!(chain, ImageResizeNearestNeighbour(outdim))
    end
    if !color
        push!(chain, x -> reshape(x, (outdim[1], outdim[2], 1)))
    end
    if gpu
        push!(chain, togpu)
    end
    ImagePreprocessor(color ? (3, 160, 210) : (160, 210), chain)
end
export AtariPreprocessor

imshowgrey(x::Array{UInt8, 2}) = imshowgrey(x[:], size(x))
imshowgrey(x::Array{UInt8, 1}, dims) = imshow(reshape(x, dims), colormap = 2)
imshowcolor(x::Array{UInt8, 3}) = imshowcolor(x[:], size(x))
function imshowcolor(x::Array{UInt8, 1}, dims)
    clearws()
    setviewport(0, dims[1]/dims[2], 0, 1)
    setwindow(0, 1, 0, 1)
    y = (zeros(UInt32, dims...) .+ 0xff) .<< 24
    img = UInt32.(x)
    @simd for i in 1:length(y)
        @inbounds y[i] += img[3*(i-1) + 1] + img[3*(i-1) + 2] << 8 + img[3*i] << 16
    end
    drawimage(0, 1, 0, 1, dims..., y)
    updatews()
end
function plotenv(env::AtariEnv, s, a, r, d)
    x = zeros(UInt8, 3 * 160 * 210)
    getScreenRGB(env.ale, x)
    imshowcolor(x, (160, 210))
end

end # module
