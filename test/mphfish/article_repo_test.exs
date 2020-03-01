defmodule Mphfish.ArticleRepoTest do
  use ExUnit.Case

  test "returns all articles" do
    expected = [
      %Mphfish.Article{
        is_draft: true,
        has_content: true,
        slug: "hello_world",
        html_content: "<h1>Hello,</h1>\n<p>world</p>\n",
        permalink: "https://mphfish.com/articles/hello_world",
        source_link:
          "https://github.com/mphfish/mphfish.com/tree/master/priv/articles/hello_world.md"
      }
    ]

    {:ok, repo} = Mphfish.ArticleRepo.start_link(article_path: "test/data/*.md")

    assert expected === Mphfish.ArticleRepo.all()

    GenServer.stop(repo)
  end

  test "returns an article by slug" do
    expected = %Mphfish.Article{
      is_draft: true,
      has_content: true,
      slug: "hello_world",
      html_content: "<h1>Hello,</h1>\n<p>world</p>\n",
      permalink: "https://mphfish.com/articles/hello_world",
      source_link:
        "https://github.com/mphfish/mphfish.com/tree/master/priv/articles/hello_world.md"
    }

    {:ok, repo} = Mphfish.ArticleRepo.start_link(article_path: "test/data/*.md")

    assert expected === Mphfish.ArticleRepo.get("hello_world")

    GenServer.stop(repo)
  end
end
