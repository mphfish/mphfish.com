defmodule Mphfish.ArticleTest do
  use ExUnit.Case

  test "processes an article string" do
    file_content = ~S(
      {
        "is_draft":true,
        "slug": "my-title"
      }
      ===
# This is a test
it is only a test
    )

    assert %Mphfish.Article{
             is_draft: true,
             has_content: true,
             slug: "my-title",
             html_content: "<h1>This is a test</h1>\n<p>it is only a test</p>\n"
           } = Mphfish.Article.compile(file_content)
  end
end
