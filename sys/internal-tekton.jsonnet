local tekton_dashboard = import 'tekton/dashboard.jsonnet';
local tekton_pipeline_base = import 'tekton/pipeline-base.jsonnet';

[
  tekton_pipeline_base,
  tekton_dashboard,
]
