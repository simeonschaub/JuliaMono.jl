using JuliaMono
using Test

if Sys.islinux() || Sys.isfreebsd()

elseif Sys.isapple()

elseif Sys.iswindows()

end


using Fontconfig_jll: fc_list

function occurences()
    fc_list() do fc_list
        open(`$fc_list`) do io
            count(contains("JuliaMono"), eachline(io))
        end
    end
end

install()
@test occurences() == 6
uninstall()
@test occurences() == 0
