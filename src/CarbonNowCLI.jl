module CarbonNowCLI

using HTTP: escapeuri

"""
	open_in_default_browser(url::AbstractString)::Bool

Open the default browser and navigate to `url`
"""
function open_in_default_browser(url::AbstractString)::Bool
    try
        if Sys.isapple()
            Base.run(`open $url`)
            true
        elseif Sys.iswindows() || detectwsl()
            Base.run(`powershell.exe Start "'$url'"`)
            true
        elseif Sys.islinux()
            Base.run(`xdg-open $url`, devnull, devnull, devnull)
            true
        else
            false
        end
    catch ex
        false
    end
end

function generate_carbon_url(;
    bg::String = "rgba(171,184,195,1)",
    theme::String = "monokai",
    window_theme::String = "night",
    language::String = "julia",
    font_family::String = "seti",
    font_size::Int = 14,
    line_numbers::Bool = false,
    code::String,
)
    query_params = [
        "bg=" * escapeuri(bg),
        "t=$theme",
        "wt=$window_theme",
        "l=$language",
        "fm=$font_family",
        "fs=$font_size",
        "ln=$(line_numbers ? "true" : "false")",
        "code=" * escapeuri(code),
    ]

    query_string = join(query_params, "&")

    base_url = "https://carbon.now.sh/"
    url = base_url * "?" * query_string

    return url
end

end # module CarbonNowCLI
