module JuliaMono

export install

using Pkg.Artifacts

const TTF_FILES = artifact"JuliaMono"

function install()
    for i in readdir(TTF_FILES)
        run(`ln -s $(joinpath(TTF_FILES, i)) $(joinpath(ENV["HOME"], ".fonts", i))`)
    end
end

end
