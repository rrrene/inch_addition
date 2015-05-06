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
    dir = System.tmp_dir!
    clone_repo(project_slug, dir)
  end

  defp clone_repo(project_slug, dir) do
    project_dir = Path.join(dir, "tmp")
    git_url = "https://github.com/#{project_slug}.git"
    System.cmd("git" , ["clone", git_url, project_dir], [cd: dir])
    System.cmd("mix" , ["deps.get"], [cd: project_dir])

    case run_inch_report(project_dir) do
      {:ok, output} -> IO.puts output
      {:error} -> IO.puts "Running Inch failed."
    end
  end

  defp env do
    [
      {"TRAVIS", "true"},
      {"TRAVIS_PULL_REQUEST", "false"}
    ]
  end

  defp run_inch_report(project_dir) do
    case System.cmd("mix" , ["inch.report"], [cd: project_dir, env: env]) do
      {output, 0} -> {:ok, output}
      {_, _} -> {:error}
    end
  end
end
