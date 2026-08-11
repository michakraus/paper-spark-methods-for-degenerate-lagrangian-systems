module SparkMethodsForDegenerateLagrangianSystems

    include("common.jl")
    include("tableau_lists.jl")

    export run_list_spark_glvprk,
           run_list_spark_glrk,
           run_list_spark_lobatto,
           run_list_vspark_internal_projection,
           run_list_vspark_modified_internal_projection,
           run_list_vspark_lobatto_IIIAIIIB_projection,
           run_list_vspark_lobatto_IIIBIIIA_projection,
           run_list_vspark_modified_lobatto_IIIAIIIB_projection,
           run_list_vspark_modified_lobatto_IIIBIIIA_projection,
           run_list_vspark_midpoint_projection,
           run_list_vspark_modified_midpoint_projection,
           run_list_vspark_symmetric_projection

    # As for the `run_list_*` above: these resolve `PI_SPEC` (and `run_list` its `make_plots`) in
    # whatever module they are called from, which is a problem module in `src/<problem>.jl`, the
    # one the weave driver hands to Weave. Called from this module they throw `UndefVarError`.
    export run_poincare_spark_glvprk,
           run_poincare_spark_glrk,
           run_poincare_spark_lobatto,
           run_poincare_vspark_internal_projection,
           run_poincare_vspark_modified_internal_projection,
           run_poincare_vspark_lobatto_IIIAIIIB_projection,
           run_poincare_vspark_lobatto_IIIBIIIA_projection,
           run_poincare_vspark_modified_lobatto_IIIAIIIB_projection,
           run_poincare_vspark_modified_lobatto_IIIBIIIA_projection,
           run_poincare_vspark_midpoint_projection,
           run_poincare_vspark_modified_midpoint_projection,
           run_poincare_vspark_symmetric_projection


    export tableaus_spark_glvprk,
           tableaus_spark_glrk,
           tableaus_spark_lobatto,
           tableaus_vspark_internal_projection,
           tableaus_vspark_modified_internal_projection,
           tableaus_vspark_lobatto_IIIAIIIB_projection,
           tableaus_vspark_lobatto_IIIBIIIA_projection,
           tableaus_vspark_modified_lobatto_IIIAIIIB_projection,
           tableaus_vspark_modified_lobatto_IIIBIIIA_projection,
           tableaus_vspark_midpoint_projection,
           tableaus_vspark_modified_midpoint_projection,
           tableaus_vspark_symmetric_projection

end
