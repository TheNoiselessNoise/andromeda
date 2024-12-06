/*
    "MainMenu": {
      "settings": {
        "appBar": customAppBarWithoutLeading("Administrační panel"),
      },
      "components": [
        columnComponent([
          detailComponent([
            [
              containerComponent(dividerComponent(3),{"margin": marginLTRB(0, 0, 0, 64)})
            ],
            // [
            //   textFormattedComponent("{arg1} + {arg2} = #{{Global.scopeNames.Attendance}}", {
            //     "arg1": "#{{Global.scopeNames.Attendance}}",
            //     "arg2": "2"
            //   }),
            // ],
            // [
            //   textFormattedComponent("{arg1} + {arg2} = #{{en_US.Global.scopeNames.Attendance}}", {
            //     "arg1": "1",
            //     "arg2": "2"
            //   }),
            // ],
            [
              textLabelComponent(">{{barcodeString}}", "#000000"),
              textLabelComponent(">{{barcodeSymbology}}", "#000000"),
              textLabelComponent(">{{scanTime}}", "#000000")
            ],
            [
              buttonComponent(
                textLabelComponent("Test ActionGroupCondition"),
                [
                  action("ActionGroupCondition", {
                    "operator": "and",
                    "conditions": [
                      action("ActionCondition", {
                        "left": "0",
                        "operator": "equals",
                        "right": "0"
                      }),
                      action("ActionCondition", {
                        "left": "1",
                        "operator": "equals",
                        "right": "1"
                      }),
                      action("ActionGroupCondition", {
                        "operator": "or",
                        "conditions": [
                          action("ActionCondition", {
                            "left": "0",
                            "operator": "equals",
                            "right": "2"
                          }),
                          action("ActionCondition", {
                            "left": "3",
                            "operator": "equals",
                            "right": "3"
                          }),
                        ],
                      }),
                    ],
                    "onTrue": [
                      action("ActionShowBasicDialog", {
                        "title": textLabelComponent("True", "#000000"),
                        "content": textLabelComponent("True", "#000000"),
                      })
                    ],
                    "onFalse": [
                      action("ActionShowBasicDialog", {
                        "title": textLabelComponent("False", "#000000"),
                        "content": textLabelComponent("False", "#000000"),
                      })
                    ]
                  })
                ]
              ),
            ],
            [
              buttonComponent(
                textLabelComponent("Test ActionCondition"),
                [
                  action("ActionCondition", {
                    "left": "0",
                    "right": "0",
                    "operator": "equals",
                    "onTrue": [
                      action("ActionShowBasicDialog", {
                        "title": textLabelComponent("True", "#000000"),
                        "content": textLabelComponent("True", "#000000"),
                      })
                    ],
                    "onFalse": [
                      action("ActionShowBasicDialog", {
                        "title": textLabelComponent("False", "#000000"),
                        "content": textLabelComponent("False", "#000000"),
                      })
                    ]
                  })
                ]
              ),
            ],
            [
              customComponent("buttonHello"),
            ],
            [
              customComponent("buttonHelloWithArgs", {
                'arg2': '!!!',
              })
            ],
            [
              textLabelComponent("Nested keys test: >{{1;>{{2;>{{3;>{{4;>{{5;5}}}}}}}}}}", "#000000"),
            ],
            [
              textLabelComponent("Nested keys test: '>{{a>{{b>{{c>{{d>{{e}}}}}}}}}}'", "#000000"),
            ],
            [
              buttonComponent(
                textLabelComponent(">{{someStoredKey;#{{Global.scopeNames.Attendance}}}}"),
                [
                  action("ActionTempStorageStore", {
                    "name": "someStoredKey",
                    "value": "#{{Global.scopeNames.AttendanceRecord}}",
                    "onKeyExists": [
                      action("ActionTempStorageDelete", {
                        "name": "someStoredKey",
                      }),
                      action("ActionRefreshPage")
                    ]
                  }),
                  action("ActionRefreshPage")
                ]
              ),
              buttonComponent(
                textLabelComponent("Delete Key"),
                [
                  action("ActionTempStorageDelete", {
                    "name": "someStoredKey",
                    "afterDelete": [
                      action("ActionRefreshPage")
                    ]
                  }),
                ]
              ),
            ],
            [
              buttonComponent(
                textLabelComponent("Skenovat kód"),
                [
                  // action("ActionShowDialogWithActions", {
                  //   "title": textLabelComponent("title", "#000000"),
                  //   "content": textLabelComponent("title", "#000000"),
                  //   "actions": [
                  //     iconButtonComponent("close", [
                  //       action("ActionNavigationPop")
                  //     ]),
                  //   ],
                  // }),

                  action("ActionPageWidget", {
                    "type": "zebraScanner",
                    "widget": "CoreZebraScannerWidget",
                    "footerComponent": columnComponent([
                      gestureDetectorComponent(
                        circularProgressIndicatorComponent(),
                        {
                          "onTapUp": [
                            action("ActionShowDialogWithActions", {
                              "title": textLabelComponent("Skenování kódu", "#000000"),
                              "content": textLabelComponent("Kód byl úspěšně naskenován!", "#000000"),
                              "actions": [
                                buttonComponent(
                                  textLabelComponent("OK"),
                                  [
                                    action("ActionNavigationPop")
                                  ]
                                ),
                              ],
                            }),
                          ],
                        }
                      ),
                    ]),
                    "onScan": [
                      action("ActionShowDialogWithActions", {
                        "title": textLabelComponent("Skenování kódu", "#000000"),
                        "content": textLabelComponent("Kód byl úspěšně naskenován!", "#000000"),
                        "actions": [
                          buttonComponent(
                            textLabelComponent("OK"),
                            [
                              action("ActionNavigationPop")
                            ]
                          ),
                        ],
                      }),
                    ],
                  })
                ]
              )
            ],
            [
              listComponent(
                overrideEntityType: "Attendance",
                enableSettings: false,
                // defaultFilters: [
                //   {"type": "in", "attribute": "id", "value": "@<{{itemsIds}}"}
                // ],
                whenEmpty: whenListEmpty(
                  listReplaceComponent: sizedBoxComponent()
                ),
                defaultOrderBy: null,
                continuousRefresh: 1000,
                headerComponent: detailComponent([
                  [
                    fieldLabelComponent("name", "Attendance"),
                    fieldLabelComponent("createdAt", "Attendance"),
                  ],
                ]),
                itemComponent: columnComponent([
                  fieldComponent("name"),
                  fieldComponent("createdAt"),
                  textLabelComponent("AttendanceRecords"),
                  listComponent(
                    overrideEntityType: "Attendance",
                    enableSettings: false,
                    defaultFilters: [
                      {"type": "in", "attribute": "id", "value": "@<{{attendanceRecordsIds}}"}
                    ],
                    whenEmpty: whenListEmpty(
                      listReplaceComponent: sizedBoxComponent()
                    ),
                    defaultOrderBy: null,
                    headerComponent: detailComponent([
                      [
                        fieldLabelComponent("name", "AttendanceRecord"),
                        fieldLabelComponent("createdAt", "AttendanceRecord"),
                      ],
                    ]),
                    itemComponent: detailComponent([
                      [
                        fieldComponent("name"),
                        fieldComponent("createdAt"),
                      ],
                    ]),
                  )
                ]),
              )
            ],
            [
              buttonComponent(
                textLabelComponent("SEND PAGE JSON"),
                [
                  action("ActionDeveloper", {
                    "what": "sendJson"
                  })
                ]
              )
            ],
            [
              buttonComponent(
                textLabelComponent("Otevřít kameru"),
                [
                  action("ActionPageWidget", {
                    "type": "camera",
                    "widget": "CoreCameraWidget",
                    "defaultCamera": "back",
                    "flashMode": "always",
                    "topComponent": textLabelComponent("Naskenujte kód", "#000000"),
                    "topWhenPhotoTakenComponent": textLabelComponent("Je fotografie v pořádku?", "#000000"),
                    // "loadingComponent": "TODO",
                    "noCameraComponent": textLabelComponent("Žádná kamera není dostupná", "#000000"),
                    "takePhotoComponent": buttonComponent(
                      textLabelComponent("Pořídit fotografii"),
                      [
                        action("ActionCameraTakePhoto")
                      ]
                    ),
                    "buttonsComponent": columnComponent([
                      buttonComponent(
                        textLabelComponent("Znovu"),
                        [
                          action("ActionCameraUnsetTakenPhoto")
                        ]
                      ),
                    ]),
                    "onPhotoTaken": [
                      action("ActionShowDialogWithActions", {
                        "title": textLabelComponent("Pořízení fotografie", "#000000"),
                        "content": textLabelComponent("Pořízení fotografie proběhlo úspěšně!", "#000000"),
                        "actions": [
                          buttonComponent(
                            textLabelComponent("OK"),
                            [
                              action("ActionNavigationPop")
                            ]
                          ),
                        ],
                      }),                        
                    ]
                  })
                ]
              )
            ],
            [
              containerComponent(dividerComponent(0), {"margin": marginLTRB(0, 64, 0, 64)})
            ],
            [
              buttonComponent(
                textLabelComponent("DEVELOPER DEBUG"),
                [
                  action("ActionDeveloper", {
                    "what": "testParse"
                  })
                ]
              )
            ],
            [
              textFormattedComponent("{arg1} + {arg2} = {arg3}", {
                "arg1": "#{{Global.scopeNames.Attendance}}",
                "arg2": "2",
                "arg3": "#{{Global.scopeNames.Attendance}}"
              })
            ],
            [
              columnComponent([
                rowComponent([
                  expandedComponent(
                    applyPaddingVH(
                      buttonComponent(
                        applyPaddingVH(
                          textLabelComponent("Příjemky"),
                          16, 0
                        ),
                        [
                          action("ActionSetPage", {
                            "page": "GoodsReceipt/list"
                          })
                        ]
                      ),
                      0, 16
                    )
                  )
                ])
              ]),
              columnComponent([
                rowComponent([
                  expandedComponent(
                    applyPaddingVH(
                      buttonComponent(
                        applyPaddingVH(
                          textLabelComponent("Výdejky"),
                          16, 0
                        ),
                        [
                          action("ActionSetPage", {
                            "page": "GoodsIssue/list"
                          })
                        ]
                      ),
                      0, 16
                    )
                  )
                ])
              ]),
            ],
            [
              sizedBoxComponent(0, 16),
            ],
            [
              columnComponent([
                rowComponent([
                  expandedComponent(
                    applyPaddingVH(
                      buttonComponent(
                        applyPaddingVH(
                          textLabelComponent("Odhlásit se"),
                          16, 0
                        ),
                        [
                          action("ActionLogout"),
                          action("ActionSetPage", {
                            "page": "Login"
                          })
                        ]
                      ),
                      0, 16
                    )
                  )
                ])
              ]),
            ]
          ])
        ])
      ]
    },

    "GoodsReceipt/view": {
      "entityType": "GoodsReceipt",
      "settings": {
        "appBar": customAppBarWithoutLeading("Goods Receipt Detail"),
      },
      "components": [
        columnComponent([
          detailComponent([
            [
              fieldLabelBoldComponent("id"),
              fieldComponent("id")
            ],
            [
              fieldLabelBoldComponent("numberField"),
              fieldComponent("numberField", true)
            ],
            [
              fieldLabelBoldComponent("integerField"),
              fieldComponent("integerField", true)
            ],
            [
              fieldLabelBoldComponent("name"),
              fieldComponent("name", true)
            ],
            [
              fieldLabelBoldComponent("status"),
              fieldComponent("status", true)
            ],
            [
              buttonComponent(
                textLabelComponent("Espo Changes"),
                [
                  action("ActionEspoChangesBottomSheet")
                ]
              )
            ],
            [
              fieldLabelBoldComponent("items"),
            ],
            [
              listComponent(
                overrideEntityType: "WarehouseItem",
                enableSettings: false,
                defaultFilters: [
                  {"type": "in", "attribute": "id", "value": "@<{{itemsIds}}"}
                ],
                whenEmpty: whenListEmpty(
                  listReplaceComponent: sizedBoxComponent()
                ),
                defaultOrderBy: null,
                continuousRefresh: 1000,
                headerComponent: detailComponent([
                  [
                    fieldLabelComponent("name"),
                    fieldLabelComponent("price"),
                    fieldLabelComponent("quantity"),
                  ],
                ]),
                itemComponent: detailComponent([
                  [
                    fieldComponent("productName"),
                    fieldComponent("price"),
                    fieldComponent("quantity")
                  ],
                ]),
              )
            ],
          ], 1000)
        ])
      ]
    },
    "GoodsReceipt/list": {
      "entityType": "GoodsReceipt",
      "settings": {
        "appBar": customAppBarWithoutLeading("Goods Receipt"),
      },
      "components": [
        listComponent(
          enableSettings: true,
          enableSettingsFilters: true,
          enableSettingsInformation: true,
          enableSettingsLimits: true,
          enableSettingsPagination: true,
          settingsFiltersFields: [
            {
              "name": "name",
              "range": "contains"
            },
            {
              "name": "status",
              "range": "anyOf"
            },
            {
              "name": "createdAt",
              "range": "between"
            }
          ],
          whenEmpty: whenListEmpty(
            paginationComponent: textLabelComponent("NOTHING FOUND", "#ff0000"),
            component: textLabelComponent("No Goods Receipts found", "#ff0000")
          ),
          divideByComponent: dividerComponent(25.0),
          continuousRefresh: 1000,
          itemComponent: detailComponent(
            [
              [
                dividerComponent()
              ],
              [
                textFormattedComponent("#{{Global.scopeNames.GoodsReceipt}} (<{{id}}) je ve statusu <{{status}}"),
              ],
              [
                dividerComponent()
              ],
              [
                rowComponent([
                  expandedComponent(
                    fieldLabelComponent("id")
                  ),
                  expandedComponent(
                    fieldComponent("id")
                  ),
                ]),
              ],
              [
                rowComponent([
                  expandedComponent(
                    fieldLabelComponent("name")
                  ),
                  expandedComponent(
                    fieldComponent("name")
                  ),
                ]),
              ],
              [
                rowComponent([
                  expandedComponent(
                    fieldLabelComponent("status")
                  ),
                  expandedComponent(
                    transFieldComponent("status")
                  ),
                ]),
              ],
              [
                rowComponent([
                  expandedComponent(
                    fieldLabelComponent("createdAt")
                  ),
                  expandedComponent(
                    fieldComponent("createdAt")
                  ),
                ]),
              ],
            ]
          ),
        ),
      ]
    },
    "GoodsIssue/view": {
      "entityType": "GoodsIssue",
      "settings": {
        "appBar": customAppBarWithoutLeading("Goods Issue Detail"),
      },
      "components": [
        columnComponent([
          detailComponent([
            [
              fieldLabelBoldComponent("id"),
              fieldComponent("id")
            ]
          ])
        ])
      ]
    },
    "GoodsIssue/list": {
      "entityType": "GoodsIssue",
      "settings": {
        "appBar": customAppBarWithoutLeading("Goods Receipt"),
      },
      "components": [
        listComponent(
          enableSettings: true,
          enableSettingsFilters: true,
          enableSettingsInformation: true,
          enableSettingsLimits: true,
          enableSettingsPagination: true,
          settingsFiltersFields: [
            {
              "name": "name",
              "range": "contains"
            },
            {
              "name": "status",
              "range": "anyOf"
            },
            {
              "name": "createdAt",
              "range": "between"
            }
          ],
          divideByComponent: dividerComponent(25.0),
          // continuousRefresh: 1000,
          // NOTE: itemComponent overrides the components
          itemComponent: detailComponent(
            [
              [
                rowComponent([
                  expandedComponent(
                    fieldLabelComponent("id")
                  ),
                  expandedComponent(
                    fieldComponent("id")
                  ),
                ]),
              ],
              [
                rowComponent([
                  expandedComponent(
                    fieldLabelComponent("name")
                  ),
                  expandedComponent(
                    fieldComponent("name")
                  ),
                ]),
              ],
              [
                rowComponent([
                  expandedComponent(
                    fieldLabelComponent("status")
                  ),
                  expandedComponent(
                    fieldComponent("status")
                  ),
                ]),
              ],
              [
                rowComponent([
                  expandedComponent(
                    fieldLabelComponent("createdAt")
                  ),
                  expandedComponent(
                    fieldComponent("createdAt")
                  ),
                ]),
              ],
            ]
          ),
        ),
      ]
    },

















    "Project/view": {
      "entityType": "Project",
      "settings": {
        "appBar": customAppBar("Project Detail"),
        "drawer": customDrawer("Drawer #1"),
      },
      "components": [
        columnComponent([
          detailComponent([
            [
              columnComponent([
                fieldLabelBoldComponent("id"),
                fieldComponent("id"),
              ])
            ],
            [
              dividerComponent(25.0)
            ],
            [
              columnComponent([
                fieldLabelBoldComponent("name"),
                fieldComponent("name"),
              ]),
              columnComponent([
                fieldLabelBoldComponent("status"),
                fieldComponent("status"),
              ])
            ],
            [
              dividerComponent(25.0)
            ],
            [
              fieldLabelBoldComponent("projectNumber"),
              fieldComponent("projectNumber", true),
            ],
            [
              fieldLabelBoldComponent("name"),
              fieldComponent("name", true),
            ],
            [
              fieldLabelBoldComponent("allowedDeviation"),
              fieldComponent("allowedDeviation", true)
            ],
            [
              fieldLabelBoldComponent("status"),
              fieldComponent("status", true),
            ],
            [
              buttonComponent(
                textLabelComponent("Go to List"),
                [
                  action("ActionSetPage", {
                    "page": "Project/list"
                  })
                ]
              ),
              buttonComponent(
                textLabelComponent("Set Archived"),
                [
                  action("AkceNastavStatusRealizaceNaArchivovano"),
                  action("ActionRefreshPage")
                ]
              ),
            ]
          ], 1000)
        ])
      ]
    },
    "Project/list": {
      "entityType": "Project",
      "settings": {
        "appBar": customAppBar("Project"),
        "drawer": customDrawer("Drawer #1"),
      },
      "components": [
        detailComponent([
          [
            textLabelComponent("List with Real Data", "#0000ff"),
          ]
        ]),
        listComponent(
          enableSettings: true,
          enableSettingsFilters: true,
          enableSettingsInformation: true,
          enableSettingsLimits: true,
          enableSettingsPagination: true,
          settingsFiltersFields: [
            {
              "name": "name",
              "range": "contains"
            },
            {
              "name": "status",
              "range": "anyOf"
            },
            {
              "name": "createdAt",
              "range": "between"
            }
          ],
          divideByComponent: dividerComponent(25.0),
          continuousRefresh: 1000,
          // NOTE: itemComponent overrides the components
          itemComponent: detailComponent(
            [
              [
                rowComponent([
                  expandedComponent(
                    fieldLabelComponent("id")
                  ),
                  expandedComponent(
                    fieldComponent("id")
                  ),
                ]),
              ],
              [
                rowComponent([
                  expandedComponent(
                    fieldLabelComponent("name")
                  ),
                  expandedComponent(
                    fieldComponent("name")
                  ),
                ]),
              ],
              [
                rowComponent([
                  expandedComponent(
                    fieldLabelComponent("status")
                  ),
                  expandedComponent(
                    fieldComponent("status")
                  ),
                ]),
              ],
              [
                rowComponent([
                  expandedComponent(
                    fieldLabelComponent("createdAt")
                  ),
                  expandedComponent(
                    fieldComponent("createdAt")
                  ),
                ]),
              ],
            ]
          ),
        ),
      ]
    */