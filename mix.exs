defmodule Monad.Mixfile do
  use Mix.Project

  def project do
    [app: :monad,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps,
      dialyzer: [
        plt_apps: [:erts, :kernel, :stdlib],
        plt_add_apps: [:mnesia],
        flags: ["-Wunmatched_returns","-Werror_handling","-Wrace_conditions", "-Wno_opaque"]
      ]
    ]
  end

  # Configuration for the OTP application
  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:dialyze, "~> 0.1.4", ony: [:dev]}]
  end
end
