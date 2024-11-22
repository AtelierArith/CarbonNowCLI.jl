using CarbonNowCLI: generate_carbon_url, open_in_default_browser

length(ARGS) == 1 || println("Usage: julia main.jl <path/to/file.jl>")

filename = ARGS[1]
code_snippet = join(readlines(filename), '\n')
language = last(splitext(filename)) == ".jl" ? "julia" : 
           last(splitext(filename)) == ".toml" ? "toml" : "auto"

url = generate_carbon_url(
    theme = "monokai",
    language = language,
    line_numbers = true,
    code = code_snippet,
)

open_in_default_browser(url)
