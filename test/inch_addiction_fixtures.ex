defmodule InchAdditionFixtures do

  def mix_config(1) do
    """
defmodule InchConfig1.Mixfile do
  use Mix.Project

  def project do
    [app: :inch_config1,
     version: "0.0.1",
     name: "inch_config1",
     source_url: "https://github.com/rrrene/inch_config1",
     elixir: "~> 1.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:poison, ">= 0.0.0"},{ :ex_doc, "~> 0.6", git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
    ]
  end
end
    """
  end

  def mix_config(2) do
    """
defmodule Ecto.Mixfile do
  use Mix.Project

  def project do
    [app: :ecto,
     version: "1.0",
     elixir: "~> 1.0",
     deps: deps,
     build_per_environment: false,
     test_paths: test_paths(Mix.env),

     # Custom testing
     aliases: ["test.all": &test_all/1],
     preferred_cli_env: ["test.all": :test],

     # Hex
     description: description,
     package: package,

     # Docs
     name: "Ecto",
     docs: [source_ref: "v1",
            source_url: "https://github.com/elixir-lang/ecto"]]
  end

  def application do
    [applications: [:logger, :decimal, :poolboy]]
  end

  defp deps do
    [{:poolboy, "~> 1.4"},
     {:decimal, "~> 1.0"},
     {:postgrex, "~> 0.8.0", optional: true},
     {:mariaex, "~> 0.1.0", optional: true},
     {:ex_doc, "~> 0.7", only: :docs},
     {:earmark, "~> 0.1", only: :docs}]
  end

  defp test_paths(_), do: ["test"]

  defp description do
    "Ecto is a domain specific language"
  end

  defp package do
    [contributors: ["Eric Meadows-Jönsson", "José Valim"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/elixir-lang/ecto"},
     files: ~w(mix.exs README.md CHANGELOG.md integration_test/cases integration_test/support lib)]
  end

  defp test_all(args) do
    args = if IO.ANSI.enabled?, do: ["--color"|args], else: ["--no-color"|args]
    Mix.Task.run "test", args

    for adapter <- @adapters do
      IO.puts "==> Running integration tests for MIX_ENV= mix test"

      {_, res} = System.cmd "mix", ["test"|args],
                            into: IO.binstream(:stdio, :line),
                            env: [{"MIX_ENV", to_string(adapter)}]

      if res > 0 do
        System.at_exit(fn _ -> exit({:shutdown, 1}) end)
      end
    end
  end
end
    """
  end

  def mix_config(3) do
    """
defmodule Phoenix.Mixfile do
  use Mix.Project


  def project do
    [app: :phoenix,
     version: "1.0",
     elixir: "~> 1.0.2 or ~> 1.1-dev",
     deps: deps,
     package: package,
     docs: [source_ref: "v", main: "overview"],
     name: "Phoenix",
     source_url: "https://github.com/phoenixframework/phoenix",
     homepage_url: "http://www.phoenixframework.org",
     description: "Elixir Web Framework"]
  end

  def application do
    [mod: {Phoenix, []},
     applications: [:plug, :poison, :logger, :eex],
     env: [template_engines: [],
           format_encoders: [],
           filter_parameters: ["password"],
           serve_endpoints: false]]
  end

  defp deps do
    [{:cowboy, "~> 1.0", optional: true},
     {:plug, ">= 0.12.2 and < 2.0.0"},
     {:poison, "~> 1.3"},
     {:redo, github: "heroku/redo", optional: true},
     {:poolboy, "~> 1.5.1 or ~> 1.6", optional: true},

     # Docs dependencies
     {:earmark, "~> 0.1", only: :docs},
     {:ex_doc, "~> 0.7.1", only: :docs},

     # Test dependencies
     {:phoenix_html, "~> 1.0", only: :test},
     {:websocket_client, github: "jeremyong/websocket_client", only: :test}]
  end

  defp package do
    [contributors: ["Chris McCord", "Darko Fabijan", "José Valim"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/phoenixframework/phoenix"}]
  end
end
    """
  end

  def mix_config(4) do
    """
defmodule Dynamo.Mixfile do
  use Mix.Project

  def project do
    [ app: :dynamo,
      elixir: "~> 0.13.3 or ~> 0.14.0-dev",
      version: "0.1.0-dev",
      name: "Dynamo",
      source_url: "https://github.com/dynamo/dynamo",
      deps: deps(Mix.env),
      docs: &docs/0 ]
  end

  def deps(:prod) do
    [ { :mime,   github: "dynamo/mime" },
      { :cowboy, github: "extend/cowboy", optional: true } ]
  end

  def deps(:docs) do
    deps(:prod) ++
      [ { :ex_doc, github: "elixir-lang/ex_doc" } ]
  end

  def deps(_) do
    deps(:prod) ++
      [ { :hackney, github: "benoitc/hackney", tag: "0.12.1" } ]
  end

  def application do
    [ applications: [:crypto],
      env: [under_test: nil],
      mod: { Dynamo.App, [] } ]
  end

  defp docs do
    [ readme: true,
      main: "README",
      source_ref: System.cmd("git rev-parse --verify --quiet HEAD") ]
  end
end
    """
  end

  def mix_config(5) do
    """
defmodule Poxa.Mixfile do
  use Mix.Project

  def project do
    [ app: :poxa,
      version: "0.4.0",
      name: "Poxa",
      elixir: "~> 1.0.0",
      deps: deps ]
  end

  def application do
    [ applications: [ :logger,
                      :crypto,
                      :gproc,
                      :cowboy ],
      included_applications: [ :exjsx, :uuid, :signaturex ],
      mod: { Poxa, [] } ]
  end

  defp deps do
    [ {:cowboy, "~> 1.0.0" },
      {:exjsx, "~> 3.0"},
      {:signaturex, "~> 0.0.8"},
      {:gproc, "~> 0.3.0"},
      {:uuid, github: "avtobiff/erlang-uuid", tag: "v0.4.5" },
      {:meck, "~> 0.8.2", only: :test},
      {:pusher_client, github: "edgurgel/pusher_client", only: :test},
      {:pusher, github: "edgurgel/pusher", only: :test},
      {:exrm, "0.14.9", only: :prod} ]
  end
end
    """
  end

  def mix_config(6) do
    """
Code.ensure_loaded?(Hex) and Hex.start

defmodule Weberderivative.Mixfile do
  use Mix.Project

  def project do
    [ app: :weberderivative,
      version: "0.1.1",
      name: "Weberderivative",
      elixir: ">= 0.13.3",
      deps: deps(Mix.env),
      source_url: "https://github.com/0xAX/weberderivative",
      homepage_url: "http://0xax.github.io/weberderivative/index.html",
      description: "weberderivative - is Elixir MVC web framework.",
      package: package
    ]
  end

  def application do
    [
      description: 'weberderivative - is Elixir MVC web framework.',
      registered: [:weberderivative],
      mod: { Weberderivative, [] },
      lager: [
        {:handlers, [
          {:lager_console_backend, :info},
          {:lager_file_backend, [{:file, "error.log"}, {:level, :error}]},
          {:lager_file_backend, [{:file, "console.log"}, {:level, :info}]},
        ]}
      ]
    ]
  end

  defp deps(_) do
    []
  end

  defp package do
    [
      files: ["lib", "test", "tmp", "templates", "examples", "README.md", "LICENSE", "ChangeLog.md", "mix.exs", "Makefile"],
      contributors: ["0xAX"],
      licenses: ["MIT"],
      links: [
              { "GitHub", "https://github.com/elixir-web/weberderivative" },
              { "Docs", "http://0xax.github.io/weberderivative/index.html" } ]
      ]
  end

end
    """
  end

  def mix_config(7) do
    """
defmodule Plug.Mixfile do
  use Mix.Project


  def project do
    [app: :plug,
     version: "1.0",
     elixir: "~> 1.0",
     deps: deps,
     package: package,
     description: "A specification and conveniences for composable " <>
                  "modules in between web applications",
     name: "Plug",
     docs: [readme: "README.md", main: "README",
            source_ref: "v1",
            source_url: "https://github.com/elixir-lang/plug"]]
  end

  # Configuration for the OTP application
  def application do
    [applications: [:crypto, :logger],
     mod: {Plug, []}]
  end

  def deps do
    [{:cowboy, "~> 1.0", optional: true},
     {:earmark, "~> 0.1", only: :docs},
     {:ex_doc, "~> 0.7", only: :docs},
     {:inch_ex, only: :docs},
     {:hackney, "~> 0.13", only: :test}]
  end

  defp package do
    %{licenses: ["Apache 2"],
      links: %{"GitHub" => "https://github.com/elixir-lang/plug"}}
  end
end
    """
  end

  def mix_config(8) do
    """
defmodule HTTPotion.Mixfile do
  use Mix.Project

  def project do
    [app: :httpotion,
     version: "2.0.0",
     elixir:  "~> 1.0",
     description: description,
     deps: deps,
     package: package]
  end

  def application do
    [applications: [:ssl, :ibrowse]]
  end

  defp description do
    "Fancy HTTP client for Elixir, based on ibrowse."
  end

  defp deps do
    [{:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.1"}]
  end

  defp package do
    [files: ["lib", "mix.exs", "README.md", "COPYING"],
     contributors: ["Greg V", "Aleksei Magusev", "pragdave", "Adam Kittelson", "Ookami Kenrou", "Guillermo Iguaran", "Sumeet Singh", "parroty", "Everton Ribeiro", "Florian J. Breunig", "Arjan van der Gaag", "Joseph Wilk", "Aidan Steele", "Paulo Almeida", "Peter Hamilton", "Steve", "Wojciech Kaczmarek", "d0rc", "falood", "Dave Thomas", "Arkar Aung", "Eduardo Gurgel", "Eito Katagiri"],
     licenses: ["Do What the Fuck You Want to Public License, Version 2"],
     links: %{ "GitHub" => "https://github.com/myfreeweb/httpotion" }]
  end
end
    """
  end

  def mix_config(9) do
    """
defmodule ReleaseManager.Mixfile do
  use Mix.Project

  def project do
    [ app: :exrm,
      version: "0.15.3",
      elixir: ">= 0.15.1 and ~> 1.0.0",
      description: description,
      package: package,
      deps: deps ]
  end

  def application, do: []

  def deps do
    [{:conform, "~> 0.13.0"},
     {:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.5", only: :dev}]
  end

  defp description do
    ""
  end

  defp package do
    [ files: ["lib", "priv", "mix.exs", "README.md", "LICENSE"],
      contributors: ["Paul Schoenfelder"],
      licenses: ["MIT"],
      links: %{ "GitHub": "https://github.com/bitwalker/exrm" } ]
  end

end
    """
  end

  def mix_config(10) do
    """
defmodule Sugar.Mixfile do
  use Mix.Project

  def project do
    [ app: :sugar,
      elixir: "~> 1.0",
      version: "0.4.7",
      name: "Sugar",
      source_url: "https://github.com/sugar-framework/sugar",
      homepage_url: "https://sugar-framework.github.io",
      deps: deps,
      package: package,
      description: description,
      docs: [readme: "README.md", main: "README"],
      test_coverage: [tool: ExCoveralls] ]
  end

  def application do
    [ applications: [ :cowboy, :plug, :templates, :poison, :ecto,
                      :postgrex, :plugs ],
      mod: { Sugar.App, [] } ]
  end

  defp deps do
    [ { :cowboy, "~> 1.0.0" },
      { :plug, "~> 0.9.0" },
      { :http_router, "~> 0.0.5" },
      { :poison, "~> 1.3.0" },
      { :ecto, "~> 0.7.1" },
      { :postgrex, "~> 0.7" },
      { :plugs, "~> 0.0.2" },
      { :templates, "~> 0.0.2" },
      { :earmark, "~> 0.1.12", only: :docs },
      { :ex_doc, "~> 0.6.2", only: :docs },
      { :excoveralls, "~> 0.3", only: :test },
      { :dialyze, "~> 0.1.3", only: :test } ]
  end

  defp description do
    "Modular web framework"
  end

  defp package do
    %{contributors: ["Shane Logsdon", "Ryan S. Northrup"],
      files: ["lib",  "mix.exs", "README.md", "LICENSE"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/sugar-framework/sugar",
               "Docs" => "https://sugar-framework.github.io/docs/"}}
  end
end
    """
  end

  def mix_config(11) do
    """
defmodule Hound.Mixfile do
  use Mix.Project

  def project do
    [ app: :hound,
      version: "0.6.0",
      elixir: ">= 1.0.2",
      description: description,
      deps: deps(Mix.env),
      package: package,
      docs: [readme: true, main: "README"]
    ]
  end


  # Configuration for the OTP application
  def application do
    [
      applications: [:httpoison],
      mod: { Hound, [] },
      description: 'Browser automation library',
    ]
  end


  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat.git" }
  defp deps do
    [
      {:httpoison, "~> 0.5.0"},
      {:poison,    "~> 1.3.0"}
    ]
  end


  defp deps(:docs) do
    deps ++ [
      { :ex_doc,  github: "elixir-lang/ex_doc" },
      { :earmark, github: "pragdave/earmark" }
    ]
  end


  defp deps(_) do
    deps
  end


  defp package do
    [
      contributors: ["Akash Manohar J"],
      licenses: ["MIT"],
      links: %{ "GitHub" => "https://github.com/HashNuke/hound" }
    ]
  end


  defp description do
    ""
  end
end
    """
  end

  def mix_config(12) do
    """
defmodule Atlas.Mixfile do
  use Mix.Project

  def project do
    [
      app: :atlas,
      version: "0.2.0",
      elixir: "~> 0.15.0",
      deps: deps,
      package: [
        contributors: ["Chris McCord", "Sonny Scroggin"],
        licenses: ["MIT"],
        links: [github: "https://github.com/chrismccord/atlas"]
      ],
      description: "Object Relational Mapper for Elixir"
    ]
  end

  # Configuration for the OTP application
  def application do
    [
      mod: { Atlas, []},
      registered: []
    ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    [{:epgsql, github: "wg/epgsql"}]
  end
end
    """
  end

  def mix_config(13) do
    """
Code.ensure_loaded?(Hex) and Hex.start

defmodule Amrita.Mixfile do
  use Mix.Project

  def project do
    [app: :amrita,
     version: version,
     name: "Amrita",
     description: "A polite, well mannered and thoroughly upstanding testing framework for Elixir",
     source_url: "https://github.com/josephwilk/amrita",
     elixir: "~> 1.0.0",
     homepage_url: "http://amrita.io",
     package: [links: %{"Website" => "http://amrita.io", "Source" => "http://github.com/josephwilk/amrita"},
              contributors: ["Joseph Wilk"],
              licenses: ["MIT"]],
     deps: deps(Mix.env)]
  end

  def version do
    String.strip(File.read!("VERSION"))
  end

  def application do
    [registered: [ExUnit.Server],
       mod: {Amrita, []},
       env: [
         # Calculated on demand
         # max_cases: :erlang.system_info(:schedulers_online),
         # seed: rand(),

         autorun: true,
         colors: [],
         trace: false,
         formatters: [Amrita.Formatter.Documentation],
         include: [],
         exclude: []]]
  end

  defp deps(:dev) do
    base_deps
  end

  defp deps(:test) do
    base_deps ++ dev_deps
  end

  defp deps(_) do
    base_deps
  end

  defp base_deps do
    [{:meck, [branch: "master" ,github: "eproxus/meck"]}]
  end

  defp dev_deps do
    [{:ex_doc, github: "elixir-lang/ex_doc"}]
  end
end
    """
  end


  def mix_config(14) do
    """
defmodule Poison.Mixfile do
  use Mix.Project


  def project do
    [app: :poison,
     version: "1.0",
     elixir: "~> 1.0",
     description: "An experimental Elixir JSON library",
     deps: deps,
     package: package]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: []]
  end

  # Dependencies can be hex.pm packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:earmark, "~> 0.1", only: :docs},
     {:ex_doc, "~> 0.7", only: :docs},
     {:benchfella, "~> 0.2", only: :bench},
     {:jiffy, github: "davisp/jiffy", only: :bench},
     {:exjsx, github: "talentdeficit/exjsx", only: :bench},
     {:jazz, github: "meh/jazz", only: :bench}]
  end

  defp package do
    [files: ~w(lib mix.exs README.md LICENSE UNLICENSE VERSION),
     contributors: ["Devin Torres"],
     licenses: ["Unlicense"],
     links: %{"GitHub" => "https://github.com/devinus/poison"}]
  end
end
    """
  end


  def mix_config(15) do
    """
defmodule Amnesia.Mixfile do
  use Mix.Project

  def project do
    [ app: :amnesia,
      version: "0.2.0",
      elixir: "~> 1.0.0-rc1",
      deps: deps,
      package: package,
      description: "mnesia wrapper for Elixir" ]
  end

  defp package do
    [ contributors: ["meh"],
      licenses: ["WTFPL"],
      links: %{"GitHub" => "https://github.com/meh/amnesia"} ]
  end

  def application do
    [ applications: [:mnesia, :logger] ]
  end

  defp deps do
    [ { :exquisite, "~> 0.1.4" } ]
  end
end
    """
  end

  def mix_config(16) do
    """
defmodule ExActor.Mixfile do
  use Mix.Project


  def project do
    [
      project: "ExActor",
      version: "1.0",
      elixir: "~> 1.0",
      app: :exactor,
      deps: deps,
      package: [
        contributors: ["Saša Jurić"],
        licenses: ["MIT"],
        links: %{
          "Github" => "https://github.com/sasa1977/exactor",
          "Docs" => "http://hexdocs.pm/exactor",
          "Changelog" => "https://github.com/sasa1977/exactor/blob/1/CHANGELOG.md#v1"
        }
      ],
      description: "Simplified creation of GenServer based processes in Elixir.",
      name: "ExActor",
      docs: [
        readme: "README.md",
        main: "ExActor.Operations",
        source_url: "https://github.com/sasa1977/exactor/",
        source_ref: @version
      ]
    ]
  end

  def application, do: [applications: [:logger]]

  defp deps do
    [
      {:ex_doc, "~> 0.7.0", only: :docs}
    ]
  end
end
    """
  end

  def mix_config(17) do
    """
defmodule HTTPoison.Mixfile do
  use Mix.Project

  @description "Yet Another HTTP client for Elixir powered by hackney"

  def project do
    [ app: :httpoison,
      version: "0.7.0",
      elixir: "~> 1.0",
      name: "HTTPoison",
      description: @description,
      package: package,
      deps: deps,
      source_url: "https://github.com/edgurgel/httpoison" ]
  end

  def application do
    [applications: [:hackney]]
  end

  defp deps do
    [
      {:hackney, "~> 1.0"},
      {:exjsx, "~> 3.1", only: :test},
      {:httparrot, "~> 0.3.4", only: :test},
      {:meck, "~> 0.8.2", only: :test},
      {:earmark, "~> 0.1", only: :docs},
      {:ex_doc, "~> 0.7", only: :docs},
    ]
  end

  defp package do
    [ contributors: ["Eduardo Gurgel Pinho"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/edgurgel/httpoison"} ]
  end
end
    """
  end

  def mix_config(18) do
    """
defmodule Postgrex.Mixfile do
  use Mix.Project

  def project do
    [app: :postgrex,
     version: "0.8.2-dev",
     elixir: "~> 1.0",
     deps: deps,
     build_per_environment: false,
     name: "Postgrex",
     source_url: "https://github.com/ericmj/postgrex",
     docs: fn ->
       {ref, 0} = System.cmd("git", ["rev-parse", "--verify", "--quiet", "HEAD"])
       [source_ref: ref, main: "README", readme: "README.md"]
     end,
     description: description,
     package: package]
  end

  # Configuration for the OTP application
  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:ex_doc, only: :dev},
     {:earmark, only: :dev},
     {:decimal, "~> 1.0"}]
  end

  defp description do
    "PostgreSQL driver for Elixir."
  end

  defp package do
    [contributors: ["Eric Meadows-Jönsson"],
     licenses: ["Apache 2.0"],
     links: %{"Github" => "https://github.com/ericmj/postgrex"}]
  end
end
    """
  end


  def mix_config(19) do
    """
defmodule Tirexs.Mixfile do
  use Mix.Project

  def project do
    [ app: :tirexs, version: "0.7.0", elixir: "~> 1.0.0", description: description, package: package, deps: deps ]
  end

  def application, do: []

  defp deps do
    [ {:exjsx, github: "talentdeficit/exjsx", tag: "v3.1.0"} ]
  end

  defp description do
    "An Elixir flavored DSL"
  end

  defp package do
    [
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/Zatvobor/tirexs", "Contributors" => "https://github.com/Zatvobor/tirexs/graphs/contributors", "Issues" => "https://github.com/Zatvobor/tirexs/issues"}
    ]
  end
end
    """
  end

  def mix_config(20) do
    """
defmodule Exredis.Mixfile do
  use Mix.Project

  def project do
    [ app: :exredis,
      version: "0.1.2",
      elixir: "~> 1.0.0",
      name: "exredis",
      source_url: "https://github.com/artemeff/exredis",
      homepage_url: "http://artemeff.github.io/exredis",
      deps: deps,
      package: package,
      description: "Redis client for Elixir",
      docs: [readme: true, main: "README.md"] ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Dependencies
  defp deps do
    [{:eredis,  ">= 1.0.7"}]
  end

  defp package do
    [
      contributors: ["Yuri Artemev", "Joakim Kolsjö", "lastcanal", "Aidan Steele",
        "Andrea Leopardi", "Ismael Abreu", "David Rouchy", "David Copeland",
        "Psi", "Andrew Forward", "Sean Stavropoulos"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/artemeff/exredis"}
    ]
  end
end
    """
  end

  def mix_config(21) do
    """
defmodule Dissentr.Mixfile do
  use Mix.Project

  def project do
    [ app: :dissentr,
      version: "0.0.1",
      elixir: "~> 0.10.0",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ registered: [:dissentr]]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    []
  end
end
    """
  end

  def mix_config(nr) do
    IO.inspect nr
    nil
  end
end