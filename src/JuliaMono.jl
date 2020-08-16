module JuliaMono

export install, uninstall

using Pkg.Artifacts

const TTF_FILES = artifact"JuliaMono"
const ARTIFACTS_TOML = find_artifacts_toml(@__FILE__)
const FONTS_DIR = Ref{String}()

function save_install_location!(install_location)
    git_tree_sha1 = create_artifact() do artifact_dir
        open(joinpath(artifact_dir, "INSTALL_LOCATION"), "w") do io
            println(io, install_location)
        end
    end

    bind_artifact!(ARTIFACTS_TOML, "INSTALL_LOCATION", git_tree_sha1)
end

function unsave_install_location!()
    artifact_dir = ensure_artifact_installed("INSTALL_LOCATION", ARTIFACTS_TOML)

    install_location = open(joinpath(artifact_dir, "INSTALL_LOCATION")) do io
        readline(io)
    end
    
    remove_artifact(artifact_hash("INSTALL_LOCATION", ARTIFACTS_TOML))
    unbind_artifact!(ARTIFACTS_TOML, "INSTALL_LOCATION")

    return install_location
end

function install()
    isassigned(FONTS_DIR) || error("Unsupported platform!")

    for i in readdir(TTF_FILES)
        run(`ln -s $(joinpath(TTF_FILES, i)) $(joinpath(FONTS_DIR[], i))`)
    end

    save_install_location!(FONTS_DIR[])
end

function uninstall()
    isassigned(FONTS_DIR) || error("Unsupported platform!")

    install_location = unsave_install_location!()

    for i in readdir(TTF_FILES)
        rm(joinpath(install_location, i))
    end
end

function __init__()
    if Sys.islinux()
        if haskey(ENV, "XDG_DATA_HOME")
            FONTS_DIR[] = joinpath(ENV["XDG_DATA_HOME"], "fonts")
        else
            FONTS_DIR[] = joinpath(homedir(), ".fonts")
        end
    elseif Sys.isapple()
        FONTS_DIR[] = joinpath(homedir(), "Library", "Fonts")
    else
        @warn "$(Sys.KERNEL) not supported"
        return
    end

    ispath(FONTS_DIR[]) || mkpath(FONTS_DIR[], mode=0o755)
    nothing
end

end
