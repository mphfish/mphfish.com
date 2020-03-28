~w(rel plugins *.exs)
|> Path.join()
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Distillery.Releases.Config,
  default_release: :default,
  default_environment: Mix.env()

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"cym2(8{&I]2iGiY=es&_A>:$KU.7U8jBuOlHk4fE[_lpko5PM)OTY&U<lKVI:!D$"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"YN.&gUt44jZY5CGy>3Nt:1hp@0/M>R~:<}&)An2[yETDuEYQh7!nTPK!&Xj4G.8o"
  set vm_args: "rel/vm.args"
end

release :mphfish do
  set version: current_version(:mphfish)

  set applications: [
        :runtime_tools
      ]

  set config_providers: [
        {Distillery.Releases.Config.Providers.Elixir, ["${RELEASE_ROOT_DIR}/etc/config.exs"]}
      ]

  set overlays: [
        {:copy, "rel/config/config.exs", "etc/config.exs"}
      ]
end
