defmodule Mix.Tasks.Add.Project do
  use Mix.Task

  @shortdoc "Add evaluation for the project to Inch CI"
  @recursive true

  @doc false
  def run(args) do
    case Enum.at(args, 0) do
      nil -> IO.puts "[ABORT] Please provide a project slug (username/repo) in project_name file."
      project_slug -> String.strip(project_slug) |> add_project_to_inch_ci
    end
  end

  defp add_project_to_inch_ci(project_slug) do
    IO.puts "project:"
    IO.inspect project_slug

    project_dir = clone_repo(project_slug, System.tmp_dir!)

    case run_inch_report(project_slug, project_dir) do
      {:ok, output} -> IO.puts output
      {:error} -> IO.puts "Running Inch failed."
    end
  end

  defp clone_repo(project_slug, dir) do
    project_dir = Path.join(dir, "tmp")
    if File.dir?(project_dir) do
      File.rm_rf(project_dir)
    end

    git_url = "https://github.com/#{project_slug}.git"
    System.cmd("git" , ["clone", git_url, project_dir], [cd: dir])

    # Add inch_ex dependency
    add_inch_ex_dependency Path.join(project_dir, "mix.exs")

    System.cmd("mix", ["deps.get"], [cd: project_dir])
    project_dir
  end

  defp add_inch_ex_dependency(mix_filename) do
    mix_content = File.read!(mix_filename)
    case InchAddition.AddInchEx.on_string(mix_content) do
      nil -> IO.puts "[ERROR] could not add :inch_ex dep"
      new_content ->
        File.write!(mix_filename, new_content)
        IO.puts "---------------------------------------------------------------"
        IO.puts new_content
        IO.puts "---------------------------------------------------------------"
    end
  end

  defp env(project_slug) do
    [
      {"MIX_ENV", "docs"},
      {"TRAVIS", "true"},
      {"TRAVIS_PULL_REQUEST", "false"},
      {"TRAVIS_REPO_SLUG", project_slug},
      {"TRAVIS_BRANCH", "master"}
    ]
  end

  defp run_inch_report(project_slug, project_dir) do
    case System.cmd("mix" , ["inch.report"], [cd: project_dir, env: env(project_slug)]) do
      {output, 0} -> {:ok, output}
      {_, _} -> {:error}
    end
  end
end
