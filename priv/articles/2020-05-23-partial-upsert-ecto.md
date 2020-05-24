{
"is_draft": false,
"slug": "2020-02-29-hell0",
"long_title": "Partial Upserts in Ecto",
"posted_at": "2020-05-23",
"copyright_year": "2020",
"short_title": "Partial Upserts in Ecto"
}
===
If your database adapter supports it, [Ecto can perform an upsert](https://hexdocs.pm/ecto/constraints-and-upserts.html#upserts) using an `on_conflict` option.

Note that `:replace_all` and `:replace_all_except` do exactly what they say: if a value is set on the record and not present in the incoming changeset, it will be nillified.

In order to preserve the existing values in the record, you can pass in the changeset changes to a `set` key:

```elixir
Repo.insert(changeset,
  on_conflict: [
    set: Enum.into([updated_at: DateTime.utc_now()], changeset.changes)
  ]
)
```
