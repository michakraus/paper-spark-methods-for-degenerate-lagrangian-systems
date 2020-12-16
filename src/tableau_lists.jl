
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
    run_list(idae, :TableauVSPARKLobattoIIIAIIIBProjection, (
            ( TableauVSPARKGLRKpLobattoIIIAIIIB(1),                 "vspark_pLobattoIIIAIIIB_glrk1"    ),
            ( TableauVSPARKGLRKpLobattoIIIAIIIB(2),                 "vspark_pLobattoIIIAIIIB_glrk2"    ),
            ( TableauVSPARKGLRKpLobattoIIIAIIIB(3),                 "vspark_pLobattoIIIAIIIB_glrk3"    ),
            ( TableauVSPARKGLRKpLobattoIIIAIIIB(4),                 "vspark_pLobattoIIIAIIIB_glrk4"    ),

            ( TableauVSPARKLobattoIIIAIIIBpLobattoIIIAIIIB(2),      "vspark_pLobattoIIIAIIIB_lobIIIAB2" ),
            ( TableauVSPARKLobattoIIIAIIIBpLobattoIIIAIIIB(3),      "vspark_pLobattoIIIAIIIB_lobIIIAB3" ),
            ( TableauVSPARKLobattoIIIAIIIBpLobattoIIIAIIIB(4),      "vspark_pLobattoIIIAIIIB_lobIIIAB4" ),
            ( TableauVSPARKLobattoIIIAIIIBpLobattoIIIAIIIB(5),      "vspark_pLobattoIIIAIIIB_lobIIIAB5" ),

            ( TableauVSPARKLobattoIIIBIIIApLobattoIIIAIIIB(2),      "vspark_pLobattoIIIAIIIB_lobIIIBA2" ),
            ( TableauVSPARKLobattoIIIBIIIApLobattoIIIAIIIB(3),      "vspark_pLobattoIIIAIIIB_lobIIIBA3" ),
            ( TableauVSPARKLobattoIIIBIIIApLobattoIIIAIIIB(4),      "vspark_pLobattoIIIAIIIB_lobIIIBA4" ),
            ( TableauVSPARKLobattoIIIBIIIApLobattoIIIAIIIB(5),      "vspark_pLobattoIIIAIIIB_lobIIIBA5" ),
        ))
end

function run_list_vspark_lobatto_IIIBIIIA_projection(idae)
    run_list(idae, :TableauVSPARKLobattoIIIBIIIAProjection, (
            ( TableauVSPARKGLRKpLobattoIIIBIIIA(1),                 "vspark_pLobattoIIIBIIIA_glrk1"     ),
            ( TableauVSPARKGLRKpLobattoIIIBIIIA(2),                 "vspark_pLobattoIIIBIIIA_glrk2"     ),
            ( TableauVSPARKGLRKpLobattoIIIBIIIA(3),                 "vspark_pLobattoIIIBIIIA_glrk3"     ),
            ( TableauVSPARKGLRKpLobattoIIIBIIIA(4),                 "vspark_pLobattoIIIBIIIA_glrk4"     ),

            ( TableauVSPARKLobattoIIIAIIIBpLobattoIIIBIIIA(2),      "vspark_pLobattoIIIBIIIA_lobIIIAB2" ),
            ( TableauVSPARKLobattoIIIAIIIBpLobattoIIIBIIIA(3),      "vspark_pLobattoIIIBIIIA_lobIIIAB3" ),
            ( TableauVSPARKLobattoIIIAIIIBpLobattoIIIBIIIA(4),      "vspark_pLobattoIIIBIIIA_lobIIIAB4" ),
            ( TableauVSPARKLobattoIIIAIIIBpLobattoIIIBIIIA(5),      "vspark_pLobattoIIIBIIIA_lobIIIAB5" ),

            ( TableauVSPARKLobattoIIIBIIIApLobattoIIIBIIIA(2),      "vspark_pLobattoIIIBIIIA_lobIIIBA2" ),
            ( TableauVSPARKLobattoIIIBIIIApLobattoIIIBIIIA(3),      "vspark_pLobattoIIIBIIIA_lobIIIBA3" ),
            ( TableauVSPARKLobattoIIIBIIIApLobattoIIIBIIIA(4),      "vspark_pLobattoIIIBIIIA_lobIIIBA4" ),
            ( TableauVSPARKLobattoIIIBIIIApLobattoIIIBIIIA(5),      "vspark_pLobattoIIIBIIIA_lobIIIBA5" ),
        ))
end

function run_list_vspark_modified_lobatto_IIIAIIIB_projection(idae)
    run_list(idae, :TableauVSPARKModifiedLobattoIIIAIIIBProjection, (
            ( TableauVSPARKGLRKpModifiedLobattoIIIAIIIB(1),             "vspark_pModifiedLobattoIIIAIIIB_glrk1"     ),
            ( TableauVSPARKGLRKpModifiedLobattoIIIAIIIB(2),             "vspark_pModifiedLobattoIIIAIIIB_glrk2"     ),
            ( TableauVSPARKGLRKpModifiedLobattoIIIAIIIB(3),             "vspark_pModifiedLobattoIIIAIIIB_glrk3"     ),
            ( TableauVSPARKGLRKpModifiedLobattoIIIAIIIB(4),             "vspark_pModifiedLobattoIIIAIIIB_glrk4"     ),

            ( TableauVSPARKLobattoIIIAIIIBpModifiedLobattoIIIAIIIB(2),  "vspark_pModifiedLobattoIIIAIIIB_lobIIIAB2" ),
            ( TableauVSPARKLobattoIIIAIIIBpModifiedLobattoIIIAIIIB(3),  "vspark_pModifiedLobattoIIIAIIIB_lobIIIAB3" ),
            ( TableauVSPARKLobattoIIIAIIIBpModifiedLobattoIIIAIIIB(4),  "vspark_pModifiedLobattoIIIAIIIB_lobIIIAB4" ),
            ( TableauVSPARKLobattoIIIAIIIBpModifiedLobattoIIIAIIIB(5),  "vspark_pModifiedLobattoIIIAIIIB_lobIIIAB5" ),

            ( TableauVSPARKLobattoIIIBIIIApModifiedLobattoIIIAIIIB(2),  "vspark_pModifiedLobattoIIIAIIIB_lobIIIBA2" ),
            ( TableauVSPARKLobattoIIIBIIIApModifiedLobattoIIIAIIIB(3),  "vspark_pModifiedLobattoIIIAIIIB_lobIIIBA3" ),
            ( TableauVSPARKLobattoIIIBIIIApModifiedLobattoIIIAIIIB(4),  "vspark_pModifiedLobattoIIIAIIIB_lobIIIBA4" ),
            ( TableauVSPARKLobattoIIIBIIIApModifiedLobattoIIIAIIIB(5),  "vspark_pModifiedLobattoIIIAIIIB_lobIIIBA5" ),
        ))
end

function run_list_vspark_modified_lobatto_IIIBIIIA_projection(idae)
    run_list(idae, :TableauVSPARKModifiedLobattoIIIBIIIAProjection, (
            ( TableauVSPARKGLRKpModifiedLobattoIIIBIIIA(1),             "vspark_pModifiedLobattoIIIBIIIA_glrk1"     ),
            ( TableauVSPARKGLRKpModifiedLobattoIIIBIIIA(2),             "vspark_pModifiedLobattoIIIBIIIA_glrk2"     ),
            ( TableauVSPARKGLRKpModifiedLobattoIIIBIIIA(3),             "vspark_pModifiedLobattoIIIBIIIA_glrk3"     ),
            ( TableauVSPARKGLRKpModifiedLobattoIIIBIIIA(4),             "vspark_pModifiedLobattoIIIBIIIA_glrk4"     ),

            ( TableauVSPARKLobattoIIIAIIIBpModifiedLobattoIIIBIIIA(2),  "vspark_pModifiedLobattoIIIBIIIA_lobIIIAB2" ),
            ( TableauVSPARKLobattoIIIAIIIBpModifiedLobattoIIIBIIIA(3),  "vspark_pModifiedLobattoIIIBIIIA_lobIIIAB3" ),
            ( TableauVSPARKLobattoIIIAIIIBpModifiedLobattoIIIBIIIA(4),  "vspark_pModifiedLobattoIIIBIIIA_lobIIIAB4" ),
            ( TableauVSPARKLobattoIIIAIIIBpModifiedLobattoIIIBIIIA(5),  "vspark_pModifiedLobattoIIIBIIIA_lobIIIAB5" ),

            ( TableauVSPARKLobattoIIIBIIIApModifiedLobattoIIIBIIIA(2),  "vspark_pModifiedLobattoIIIBIIIA_lobIIIBA2" ),
            ( TableauVSPARKLobattoIIIBIIIApModifiedLobattoIIIBIIIA(3),  "vspark_pModifiedLobattoIIIBIIIA_lobIIIBA3" ),
            ( TableauVSPARKLobattoIIIBIIIApModifiedLobattoIIIBIIIA(4),  "vspark_pModifiedLobattoIIIBIIIA_lobIIIBA4" ),
            ( TableauVSPARKLobattoIIIBIIIApModifiedLobattoIIIBIIIA(5),  "vspark_pModifiedLobattoIIIBIIIA_lobIIIBA5" ),
        ))
end

function run_list_vspark_midpoint_projection(idae)
    run_list(idae, :TableauVSPARKMidpointProjection, (
        ( TableauVSPARKGLRKpMidpoint(1),                            "vspark_pMidpoint_glrk1"     ),
        ( TableauVSPARKGLRKpMidpoint(2),                            "vspark_pMidpoint_glrk2"     ),
        ( TableauVSPARKGLRKpMidpoint(3),                            "vspark_pMidpoint_glrk3"     ),
        ( TableauVSPARKGLRKpMidpoint(4),                            "vspark_pMidpoint_glrk4"     ),

        ( TableauVSPARKLobattoIIIAIIIBpMidpoint(2),                 "vspark_pMidpoint_lobIIIAB2" ),
        ( TableauVSPARKLobattoIIIAIIIBpMidpoint(3),                 "vspark_pMidpoint_lobIIIAB3" ),
        ( TableauVSPARKLobattoIIIAIIIBpMidpoint(4),                 "vspark_pMidpoint_lobIIIAB4" ),
        ( TableauVSPARKLobattoIIIAIIIBpMidpoint(5),                 "vspark_pMidpoint_lobIIIAB5" ),

        ( TableauVSPARKLobattoIIIBIIIApMidpoint(2),                 "vspark_pMidpoint_lobIIIBA2" ),
        ( TableauVSPARKLobattoIIIBIIIApMidpoint(3),                 "vspark_pMidpoint_lobIIIBA3" ),
        ( TableauVSPARKLobattoIIIBIIIApMidpoint(4),                 "vspark_pMidpoint_lobIIIBA4" ),
        ( TableauVSPARKLobattoIIIBIIIApMidpoint(5),                 "vspark_pMidpoint_lobIIIBA5" ),
        ))
end

function run_list_vspark_modified_midpoint_projection(idae)
    run_list(idae, :TableauVSPARKModifiedMidpointProjection, (
        ( TableauVSPARKGLRKpModifiedMidpoint(1),                    "vspark_pModifiedMidpoint_glrk1"     ),
        ( TableauVSPARKGLRKpModifiedMidpoint(2),                    "vspark_pModifiedMidpoint_glrk2"     ),
        ( TableauVSPARKGLRKpModifiedMidpoint(3),                    "vspark_pModifiedMidpoint_glrk3"     ),
        ( TableauVSPARKGLRKpModifiedMidpoint(4),                    "vspark_pModifiedMidpoint_glrk4"     ),

        ( TableauVSPARKLobattoIIIAIIIBpModifiedMidpoint(2),         "vspark_pModifiedMidpoint_lobIIIAB2" ),
        ( TableauVSPARKLobattoIIIAIIIBpModifiedMidpoint(3),         "vspark_pModifiedMidpoint_lobIIIAB3" ),
        ( TableauVSPARKLobattoIIIAIIIBpModifiedMidpoint(4),         "vspark_pModifiedMidpoint_lobIIIAB4" ),
        ( TableauVSPARKLobattoIIIAIIIBpModifiedMidpoint(5),         "vspark_pModifiedMidpoint_lobIIIAB5" ),

        ( TableauVSPARKLobattoIIIBIIIApModifiedMidpoint(2),         "vspark_pModifiedMidpoint_lobIIIBA2" ),
        ( TableauVSPARKLobattoIIIBIIIApModifiedMidpoint(3),         "vspark_pModifiedMidpoint_lobIIIBA3" ),
        ( TableauVSPARKLobattoIIIBIIIApModifiedMidpoint(4),         "vspark_pModifiedMidpoint_lobIIIBA4" ),
        ( TableauVSPARKLobattoIIIBIIIApModifiedMidpoint(5),         "vspark_pModifiedMidpoint_lobIIIBA5" ),
        ))
end

function run_list_vspark_symmetric_projection(idae)
run_list(idae, :TableauVSPARKSymmetricProjection, (
        ( TableauVSPARKGLRKpSymmetric(1),                           "vspark_pSymmetric_glrk1"     ),
        ( TableauVSPARKGLRKpSymmetric(2),                           "vspark_pSymmetric_glrk2"     ),
        ( TableauVSPARKGLRKpSymmetric(3),                           "vspark_pSymmetric_glrk3"     ),
        ( TableauVSPARKGLRKpSymmetric(4),                           "vspark_pSymmetric_glrk4"     ),

        ( TableauVSPARKLobattoIIIAIIIBpSymmetric(2),                "vspark_pSymmetric_lobIIIAB2" ),
        ( TableauVSPARKLobattoIIIAIIIBpSymmetric(3),                "vspark_pSymmetric_lobIIIAB3" ),
        ( TableauVSPARKLobattoIIIAIIIBpSymmetric(4),                "vspark_pSymmetric_lobIIIAB4" ),
        ( TableauVSPARKLobattoIIIAIIIBpSymmetric(5),                "vspark_pSymmetric_lobIIIAB5" ),

        ( TableauVSPARKLobattoIIIBIIIApSymmetric(2),                "vspark_pSymmetric_lobIIIBA2" ),
        ( TableauVSPARKLobattoIIIBIIIApSymmetric(3),                "vspark_pSymmetric_lobIIIBA3" ),
        ( TableauVSPARKLobattoIIIBIIIApSymmetric(4),                "vspark_pSymmetric_lobIIIBA4" ),
        ( TableauVSPARKLobattoIIIBIIIApSymmetric(5),                "vspark_pSymmetric_lobIIIBA5" ),
    ))
end
