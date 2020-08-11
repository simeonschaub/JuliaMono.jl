module JuliaMono

export install

using Pkg.Artifacts

const TTF_FILES = artifact"JuliaMono"

function install()
    for i in readdir(TTF_FILES)
        fontfolder = haskey(ENV, "XDG_DATA_HOME") ?
                         joinpath(ENV["XDG_DATA_HOME"], "fonts") :
                         joinpath(homedir(), ".fonts")
        run(`ln -s $(joinpath(TTF_FILES, i)) $(joinpath(fontfolder, i))`)
    end
end

end
