defmodule CspDashboardPhxWeb.ViolationReportHTML do
  use CspDashboardPhxWeb, :html

  embed_templates "violation_report_html/*"

  defp pagination_opts do
    [
      wrapper_attrs: [class: "flex gap-2 my-5"],
      pagination_list_attrs: [class: ["flex gap-4 order-2"]],
      previous_link_attrs: [class: "order-1 hero-chevron-left-mini"],
      next_link_attrs: [class: "order-3 hero-chevron-right-mini"],
      page_links: {:ellipsis, 5}
    ]
  end

  def table_opts do
    [
      table_attrs: [class: "w-full border-collapse border border-slate-400"],
      thead_th_attrs: [class: "p-2 bg-gray-50 border border-slate-300"],
      tbody_attr: [class: ""],
      tbody_tr_attrs: [class: "hover:bg-zinc-50 hover:cursor-pointer"],
      tbody_td_attrs: [class: "p-2 border border-slate-300"]
    ]
  end
end
