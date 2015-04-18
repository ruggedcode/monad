defmodule Monad.Mixfile do
  use Mix.Project

  def project do
    [app: :monad,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  # Configuration for the OTP application
  def application do
    [applications: [:logger]]
  end

  defp deps do
    []
  end
end
