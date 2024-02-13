defmodule CspDashboardPhxWeb.Live.Helpers do
  use CspDashboardPhxWeb, :live_view

  def truncate(text, opts \\ []) do
    max_length = opts[:max_length] || 50
    omission   = opts[:omission] || "..."

    cond do
      not is_bitstring(text) ->
        text
      not String.valid?(text) ->
        text
      String.length(text) < max_length  ->
        text
      true ->
        length_with_omission = max_length - String.length(omission)

        text
        |> String.slice(0, length_with_omission)
        |> String.trim()
        |> then(&"#{&1}#{omission}")
    end
  end

  attr :fields, :list, required: true
  attr :meta, Flop.Meta, required: true
  attr :id, :string, default: nil
  attr :on_change, :string, default: "update-filter"
  attr :target, :string, default: nil
  slot :inner_block

  def filter_form(%{meta: meta} = assigns) do
    assigns = assign(assigns, form: Phoenix.Component.to_form(meta), meta: nil)

    ~H"""
    <.simple_form
      for={@form}
      id={@id}
      phx-target={@target}
      phx-change={@on_change}
      phx-submit={@on_change}
    >
      <Flop.Phoenix.filter_fields :let={i} form={@form} fields={@fields}>
        <.input
          field={i.field}
          label={i.label}
          type={i.type}
          phx-debounce={120}
          {i.rest}
        />
      </Flop.Phoenix.filter_fields>
      <:actions>
        <.link phx-click="reset-filter" class="btn">Reset</.link>
      </:actions>
    </.simple_form>
    """
  end

  def pagination_opts do
    [
      wrapper_attrs: [class: "flex gap-2"],
      pagination_list_attrs: [class: ["flex gap-4 order-2"]],
      pagination_link_attrs: [class: ["px-2 py-1"]],
      previous_link_attrs: [class: "order-1 hero-chevron-left-mini"],
      next_link_attrs: [class: "order-3 hero-chevron-right-mini"],
      page_links: {:ellipsis, 5},
      current_link_attrs: [class: "bg-zinc-200 px-2 px-1 is-current"]
    ]
  end

  def table_opts do
    [
      table_attrs: [class: "w-full border-collapse border border-slate-400"],
      thead_th_attrs: [class: "p-2 bg-gray-50 border border-slate-300"],
      tbody_attr: [class: ""],
      tbody_tr_attrs: [class: "hover:bg-zinc-50"],
      tbody_td_attrs: [class: "p-2 border border-slate-300"]
    ]
  end
end
