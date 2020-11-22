
function run_list_spark_glvprk(idae)
    run_list(idae, :TableauSPARKGLVPRK, (
            ( TableauSPARKGLVPRK(1),     "spark_glvprk1" ),
            ( TableauSPARKGLVPRK(2),     "spark_glvprk2" ),
            ( TableauSPARKGLVPRK(3),     "spark_glvprk3" ),
            ( TableauSPARKGLVPRK(4),     "spark_glvprk4" ),
        ))
end

function run_list_spark_glrk(idae)
    run_list(idae, :TableauSPARKGLRK, (
            ( TableauSPARKGLRK(1),       "spark_glrk1" ),
            ( TableauSPARKGLRK(2),       "spark_glrk2" ),
            ( TableauSPARKGLRK(3),       "spark_glrk3" ),
            ( TableauSPARKGLRK(4),       "spark_glrk4" ),
        ))
end

function run_list_spark_lobatto(idae)
    run_list(idae, :TableauSPARKLobatto, (
            ( TableauSPARKLobABC(2),     "spark_lobIIIABC2"    ),
            ( TableauSPARKLobABC(3),     "spark_lobIIIABC3"    ),
            ( TableauSPARKLobABC(4),     "spark_lobIIIABC4"    ),
            ( TableauSPARKLobABC(5),     "spark_lobIIIABC5"    ),

            ( TableauSPARKLobABD(2),     "spark_lobIIIABD2"    ),
            ( TableauSPARKLobABD(3),     "spark_lobIIIABD3"    ),
            ( TableauSPARKLobABD(4),     "spark_lobIIIABD4"    ),
            ( TableauSPARKLobABD(5),     "spark_lobIIIABD5"    ),
        ))
end

function run_list_vspark_internal_projection(idae)
    run_list(idae, :TableauVSPARKInternalProjection, (
            ( TableauVSPARKGLRKpInternal(1),                    "vspark_pInternal_glrk1" ),
            ( TableauVSPARKGLRKpInternal(2),                    "vspark_pInternal_glrk2" ),
            ( TableauVSPARKGLRKpInternal(3),                    "vspark_pInternal_glrk3" ),
            ( TableauVSPARKGLRKpInternal(4),                    "vspark_pInternal_glrk4" ),
        ); phi_average = Φ -> sum(Φ))
end

function run_list_vspark_modified_internal_projection(idae)
    run_list(idae, :TableauVSPARKModifiedInternalProjection, (
            ( TableauVSPARKGLRKpModifiedInternal(1),            "vspark_pModifiedInternal_glrk1" ),
            ( TableauVSPARKGLRKpModifiedInternal(2),            "vspark_pModifiedInternal_glrk2" ),
            ( TableauVSPARKGLRKpModifiedInternal(3),            "vspark_pModifiedInternal_glrk3" ),
            ( TableauVSPARKGLRKpModifiedInternal(4),            "vspark_pModifiedInternal_glrk4" ),
        ); phi_average = Φ -> sum(Φ))
end

function run_list_vspark_lobatto_IIIAIIIB_projection(idae)
    run_list(idae, :TableauVSPARKLobIIIAIIIBProjection, (
            ( TableauVSPARKGLRKpLobIIIAIIIB(1),                 "vspark_pLobIIIAIIIB_glrk1"    ),
            ( TableauVSPARKGLRKpLobIIIAIIIB(2),                 "vspark_pLobIIIAIIIB_glrk2"    ),
            ( TableauVSPARKGLRKpLobIIIAIIIB(3),                 "vspark_pLobIIIAIIIB_glrk3"    ),
            ( TableauVSPARKGLRKpLobIIIAIIIB(4),                 "vspark_pLobIIIAIIIB_glrk4"    ),

            ( TableauVSPARKLobIIIAIIIBpLobIIIAIIIB(2),          "vspark_pLobIIIAIIIB_lobIIIAB2" ),
            ( TableauVSPARKLobIIIAIIIBpLobIIIAIIIB(3),          "vspark_pLobIIIAIIIB_lobIIIAB3" ),
            ( TableauVSPARKLobIIIAIIIBpLobIIIAIIIB(4),          "vspark_pLobIIIAIIIB_lobIIIAB4" ),
            ( TableauVSPARKLobIIIAIIIBpLobIIIAIIIB(5),          "vspark_pLobIIIAIIIB_lobIIIAB5" ),

            ( TableauVSPARKLobIIIBIIIApLobIIIAIIIB(2),          "vspark_pLobIIIAIIIB_lobIIIBA2" ),
            ( TableauVSPARKLobIIIBIIIApLobIIIAIIIB(3),          "vspark_pLobIIIAIIIB_lobIIIBA3" ),
            ( TableauVSPARKLobIIIBIIIApLobIIIAIIIB(4),          "vspark_pLobIIIAIIIB_lobIIIBA4" ),
            ( TableauVSPARKLobIIIBIIIApLobIIIAIIIB(5),          "vspark_pLobIIIAIIIB_lobIIIBA5" ),
        ))
end

function run_list_vspark_lobatto_IIIBIIIA_projection(idae)
    run_list(idae, :TableauVSPARKLobIIIBIIIAProjection, (
            ( TableauVSPARKGLRKpLobIIIBIIIA(1),                 "vspark_pLobIIIBIIIA_glrk1"     ),
            ( TableauVSPARKGLRKpLobIIIBIIIA(2),                 "vspark_pLobIIIBIIIA_glrk2"     ),
            ( TableauVSPARKGLRKpLobIIIBIIIA(3),                 "vspark_pLobIIIBIIIA_glrk3"     ),
            ( TableauVSPARKGLRKpLobIIIBIIIA(4),                 "vspark_pLobIIIBIIIA_glrk4"     ),

            ( TableauVSPARKLobIIIAIIIBpLobIIIBIIIA(2),          "vspark_pLobIIIBIIIA_lobIIIAB2" ),
            ( TableauVSPARKLobIIIAIIIBpLobIIIBIIIA(3),          "vspark_pLobIIIBIIIA_lobIIIAB3" ),
            ( TableauVSPARKLobIIIAIIIBpLobIIIBIIIA(4),          "vspark_pLobIIIBIIIA_lobIIIAB4" ),
            ( TableauVSPARKLobIIIAIIIBpLobIIIBIIIA(5),          "vspark_pLobIIIBIIIA_lobIIIAB5" ),

            ( TableauVSPARKLobIIIBIIIApLobIIIBIIIA(2),          "vspark_pLobIIIBIIIA_lobIIIBA2" ),
            ( TableauVSPARKLobIIIBIIIApLobIIIBIIIA(3),          "vspark_pLobIIIBIIIA_lobIIIBA3" ),
            ( TableauVSPARKLobIIIBIIIApLobIIIBIIIA(4),          "vspark_pLobIIIBIIIA_lobIIIBA4" ),
            ( TableauVSPARKLobIIIBIIIApLobIIIBIIIA(5),          "vspark_pLobIIIBIIIA_lobIIIBA5" ),
        ))
end

function run_list_vspark_modified_lobatto_IIIAIIIB_projection(idae)
    run_list(idae, :TableauVSPARKModifiedLobIIIAIIIBProjection, (
            ( TableauVSPARKGLRKpModifiedLobIIIAIIIB(1),         "vspark_pModifiedLobIIIAIIIB_glrk1"     ),
            ( TableauVSPARKGLRKpModifiedLobIIIAIIIB(2),         "vspark_pModifiedLobIIIAIIIB_glrk2"     ),
            ( TableauVSPARKGLRKpModifiedLobIIIAIIIB(3),         "vspark_pModifiedLobIIIAIIIB_glrk3"     ),
            ( TableauVSPARKGLRKpModifiedLobIIIAIIIB(4),         "vspark_pModifiedLobIIIAIIIB_glrk4"     ),

            ( TableauVSPARKLobIIIAIIIBpModifiedLobIIIAIIIB(2),  "vspark_pModifiedLobIIIAIIIB_lobIIIAB2" ),
            ( TableauVSPARKLobIIIAIIIBpModifiedLobIIIAIIIB(3),  "vspark_pModifiedLobIIIAIIIB_lobIIIAB3" ),
            ( TableauVSPARKLobIIIAIIIBpModifiedLobIIIAIIIB(4),  "vspark_pModifiedLobIIIAIIIB_lobIIIAB4" ),
            ( TableauVSPARKLobIIIAIIIBpModifiedLobIIIAIIIB(5),  "vspark_pModifiedLobIIIAIIIB_lobIIIAB5" ),

            ( TableauVSPARKLobIIIBIIIApModifiedLobIIIAIIIB(2),  "vspark_pModifiedLobIIIAIIIB_lobIIIBA2" ),
            ( TableauVSPARKLobIIIBIIIApModifiedLobIIIAIIIB(3),  "vspark_pModifiedLobIIIAIIIB_lobIIIBA3" ),
            ( TableauVSPARKLobIIIBIIIApModifiedLobIIIAIIIB(4),  "vspark_pModifiedLobIIIAIIIB_lobIIIBA4" ),
            ( TableauVSPARKLobIIIBIIIApModifiedLobIIIAIIIB(5),  "vspark_pModifiedLobIIIAIIIB_lobIIIBA5" ),
        ))
end

function run_list_vspark_modified_lobatto_IIIBIIIA_projection(idae)
    run_list(idae, :TableauVSPARKModifiedLobIIIBIIIAProjection, (
            ( TableauVSPARKGLRKpModifiedLobIIIBIIIA(1),         "vspark_pModifiedLobIIIBIIIA_glrk1"     ),
            ( TableauVSPARKGLRKpModifiedLobIIIBIIIA(2),         "vspark_pModifiedLobIIIBIIIA_glrk2"     ),
            ( TableauVSPARKGLRKpModifiedLobIIIBIIIA(3),         "vspark_pModifiedLobIIIBIIIA_glrk3"     ),
            ( TableauVSPARKGLRKpModifiedLobIIIBIIIA(4),         "vspark_pModifiedLobIIIBIIIA_glrk4"     ),

            ( TableauVSPARKLobIIIAIIIBpModifiedLobIIIBIIIA(2),  "vspark_pModifiedLobIIIBIIIA_lobIIIAB2" ),
            ( TableauVSPARKLobIIIAIIIBpModifiedLobIIIBIIIA(3),  "vspark_pModifiedLobIIIBIIIA_lobIIIAB3" ),
            ( TableauVSPARKLobIIIAIIIBpModifiedLobIIIBIIIA(4),  "vspark_pModifiedLobIIIBIIIA_lobIIIAB4" ),
            ( TableauVSPARKLobIIIAIIIBpModifiedLobIIIBIIIA(5),  "vspark_pModifiedLobIIIBIIIA_lobIIIAB5" ),

            ( TableauVSPARKLobIIIBIIIApModifiedLobIIIBIIIA(2),  "vspark_pModifiedLobIIIBIIIA_lobIIIBA2" ),
            ( TableauVSPARKLobIIIBIIIApModifiedLobIIIBIIIA(3),  "vspark_pModifiedLobIIIBIIIA_lobIIIBA3" ),
            ( TableauVSPARKLobIIIBIIIApModifiedLobIIIBIIIA(4),  "vspark_pModifiedLobIIIBIIIA_lobIIIBA4" ),
            ( TableauVSPARKLobIIIBIIIApModifiedLobIIIBIIIA(5),  "vspark_pModifiedLobIIIBIIIA_lobIIIBA5" ),
        ))
end

function run_list_vspark_midpoint_projection(idae)
    run_list(idae, :TableauVSPARKMidpointProjection, (
        ( TableauVSPARKGLRKpMidpoint(1),                        "vspark_pMidpoint_glrk1"     ),
        ( TableauVSPARKGLRKpMidpoint(2),                        "vspark_pMidpoint_glrk2"     ),
        ( TableauVSPARKGLRKpMidpoint(3),                        "vspark_pMidpoint_glrk3"     ),
        ( TableauVSPARKGLRKpMidpoint(4),                        "vspark_pMidpoint_glrk4"     ),

        ( TableauVSPARKLobIIIAIIIBpMidpoint(2),                 "vspark_pMidpoint_lobIIIAB2" ),
        ( TableauVSPARKLobIIIAIIIBpMidpoint(3),                 "vspark_pMidpoint_lobIIIAB3" ),
        ( TableauVSPARKLobIIIAIIIBpMidpoint(4),                 "vspark_pMidpoint_lobIIIAB4" ),
        ( TableauVSPARKLobIIIAIIIBpMidpoint(5),                 "vspark_pMidpoint_lobIIIAB5" ),

        ( TableauVSPARKLobIIIBIIIApMidpoint(2),                 "vspark_pMidpoint_lobIIIBA2" ),
        ( TableauVSPARKLobIIIBIIIApMidpoint(3),                 "vspark_pMidpoint_lobIIIBA3" ),
        ( TableauVSPARKLobIIIBIIIApMidpoint(4),                 "vspark_pMidpoint_lobIIIBA4" ),
        ( TableauVSPARKLobIIIBIIIApMidpoint(5),                 "vspark_pMidpoint_lobIIIBA5" ),
        ))
end

function run_list_vspark_modified_midpoint_projection(idae)
    run_list(idae, :TableauVSPARKModifiedMidpointProjection, (
        ( TableauVSPARKGLRKpModifiedMidpoint(1),                "vspark_pModifiedMidpoint_glrk1"     ),
        ( TableauVSPARKGLRKpModifiedMidpoint(2),                "vspark_pModifiedMidpoint_glrk2"     ),
        ( TableauVSPARKGLRKpModifiedMidpoint(3),                "vspark_pModifiedMidpoint_glrk3"     ),
        ( TableauVSPARKGLRKpModifiedMidpoint(4),                "vspark_pModifiedMidpoint_glrk4"     ),

        ( TableauVSPARKLobIIIAIIIBpModifiedMidpoint(2),         "vspark_pModifiedMidpoint_lobIIIAB2" ),
        ( TableauVSPARKLobIIIAIIIBpModifiedMidpoint(3),         "vspark_pModifiedMidpoint_lobIIIAB3" ),
        ( TableauVSPARKLobIIIAIIIBpModifiedMidpoint(4),         "vspark_pModifiedMidpoint_lobIIIAB4" ),
        ( TableauVSPARKLobIIIAIIIBpModifiedMidpoint(5),         "vspark_pModifiedMidpoint_lobIIIAB5" ),

        ( TableauVSPARKLobIIIBIIIApModifiedMidpoint(2),         "vspark_pModifiedMidpoint_lobIIIBA2" ),
        ( TableauVSPARKLobIIIBIIIApModifiedMidpoint(3),         "vspark_pModifiedMidpoint_lobIIIBA3" ),
        ( TableauVSPARKLobIIIBIIIApModifiedMidpoint(4),         "vspark_pModifiedMidpoint_lobIIIBA4" ),
        ( TableauVSPARKLobIIIBIIIApModifiedMidpoint(5),         "vspark_pModifiedMidpoint_lobIIIBA5" ),
        ))
end

function run_list_vspark_symmetric_projection(idae)
run_list(idae, :TableauVSPARKSymmetricProjection, (
        ( TableauVSPARKGLRKpSymmetric(1),                       "vspark_pSymmetric_glrk1"     ),
        ( TableauVSPARKGLRKpSymmetric(2),                       "vspark_pSymmetric_glrk2"     ),
        ( TableauVSPARKGLRKpSymmetric(3),                       "vspark_pSymmetric_glrk3"     ),
        ( TableauVSPARKGLRKpSymmetric(4),                       "vspark_pSymmetric_glrk4"     ),

        ( TableauVSPARKLobIIIAIIIBpSymmetric(2),                "vspark_pSymmetric_lobIIIAB2" ),
        ( TableauVSPARKLobIIIAIIIBpSymmetric(3),                "vspark_pSymmetric_lobIIIAB3" ),
        ( TableauVSPARKLobIIIAIIIBpSymmetric(4),                "vspark_pSymmetric_lobIIIAB4" ),
        ( TableauVSPARKLobIIIAIIIBpSymmetric(5),                "vspark_pSymmetric_lobIIIAB5" ),

        ( TableauVSPARKLobIIIBIIIApSymmetric(2),                "vspark_pSymmetric_lobIIIBA2" ),
        ( TableauVSPARKLobIIIBIIIApSymmetric(3),                "vspark_pSymmetric_lobIIIBA3" ),
        ( TableauVSPARKLobIIIBIIIApSymmetric(4),                "vspark_pSymmetric_lobIIIBA4" ),
        ( TableauVSPARKLobIIIBIIIApSymmetric(5),                "vspark_pSymmetric_lobIIIBA5" ),
    ))
end
