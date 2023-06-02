local tekton_dashboard = import '../lib/tekton/dashboard.jsonnet';
local tekton_pipeline_base = import '../lib/tekton/pipeline-base.jsonnet';

[
  tekton_pipeline_base,
  tekton_dashboard,
]
