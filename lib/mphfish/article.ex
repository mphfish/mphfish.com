defmodule Mphfish.Article do
  @moduledoc false
  @project_source Mix.Project.config()[:source_url]

  defstruct [
    :is_draft,
    :slug,
    :long_title,
    :posted_at,
    :copyright_year,
    :short_title,
    :html_content,
    :md_content,
    :has_content,
    :source_link,
    :permalink
  ]

  @type t :: %__MODULE__{
          is_draft: boolean(),
          slug: String.t(),
          long_title: String.t(),
          posted_at: DateTime.t(),
          copyright_year: String.t(),
          short_title: String.t(),
          html_content: String.t(),
          md_content: String.t(),
          has_content: boolean(),
          source_link: String.t(),
          permalink: String.t()
        }

  @spec compile(String.t()) :: %__MODULE__{}
  def compile(raw_string) do
    [headers, md_content] = String.split(raw_string, "===\n", parts: 2, trim: true)

    html_content =
      Earmark.as_html!(md_content, %Earmark.Options{code_class_prefix: "lang- language-"})

    headers =
      %{slug: slug} =
      headers
      |> Jason.decode!()
      |> MapUtil.elixirize()

    compiled =
      headers
      |> Map.put(:html_content, html_content)
      |> Map.put(:has_content, String.length(html_content) !== 0)
      |> Map.put(:source_link, "#{@project_source}/tree/master/priv/articles/#{slug}.md")
      |> Map.put(:permalink, "https://mphfish.com/articles/#{slug}")

    struct(__MODULE__, compiled)
  end
end
