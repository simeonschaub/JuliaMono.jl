module JuliaMono

export install

import Pkg
using Pkg.Artifacts

const TTF_FILES = artifact"JuliaMono"
const ARTIFACTS_TOML = find_artifacts_toml(@__LINE__)

function save_install_location!(install_location)
    git_tree_sha1 = create_artifact() do artifact_dir
        open(joinpath(artifact_dir, "INSTALL_LOCATION"), "w") do io
            println(io, install_location)
        end
    end

    bind_artifact!(ARTIFACTS_TOML, "INSTALL_LOCATION", git_tree_sha_1)
end

function unsave_install_location!()
    artifact_dir = ensure_artifact_installed("INSTALL_LOCATION", ARTIFACTS_TOML)

    install_location = open(joinpath(artifact_dir, "INSTALL_LOCATION")) do io
        readline(io)
    end
    
    remove_artifact!(artifact_hash("INSTALL_LOCATION", ARTIFACTS_TOML))
    unbind_artifact!(ARTIFACTS_TOML, "INSTALL_LOCATION")

    return install_location
end

function install()
    for i in readdir(TTF_FILES)
        fontfolder = haskey(ENV, "XDG_DATA_HOME") ?
                         joinpath(ENV["XDG_DATA_HOME"], "fonts") :
                         joinpath(homedir(), ".fonts")
        run(`ln -s $(joinpath(TTF_FILES, i)) $(joinpath(fontfolder, i))`)
    end
end

end
