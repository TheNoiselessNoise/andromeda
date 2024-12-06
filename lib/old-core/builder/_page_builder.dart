import 'package:andromeda/old-core/core.dart';

// >>>>>>>>>>>>>>>>>>>>>> STRING FORMAT >>>>>>>>>>>>>>>>>>>>>>

// #{{path.to.metadata.i18n}}
// this will be replaced with the value in the path of the i18n
// each dot in the path is a level deeper in the map

// #{{cs_CZ.path.to.metadata.i18n}}
// with this you can override the language, otherwise it will use
// the language application is currently using

// <{{attributeInEntity}}
// this will be replaced with the value of the attribute in the entity

// >{{storage}}
// >{{storage;defaultValue}}
// >{{storage;}}
// this will be replaced with the value in the temporary storage

// !{{customValue}}
// this will be replaced with the value in the custom values

// ={{formId.fieldId}}
// this will be replaced with the value in the form

// nesting is also possible
// let's say we have key 'id' with value 'superId'
// let's say we have format '<{{id<{{id}}}}'
// result will be '<{{idsuperId}}
// because we don't have key 'idsuperId'
// if we have key 'idsuperId' with value 'someValue'
// result from '<{{idsuperId}}' will be 'someValue'

// '@<{{itemsIds}}'
// '@' is a special character that says whatever is in the {{path}}
// don't replace it in the same string but replace the whole string with the (dynamic) value
// in this case we know itemsIds is linkMultiple returning array of ids
// so "@<{{itemsIds}}" will be replaced with the array of ids
// meaning the type will not be String, but List<String>
// is that clear enough?

// @#{{path.to.metadata.i18n}}
// @<{{attributeInEntity}}
// this is also possible, see '@' description above

// >>>>>>>>>>>>>>>>>>>>>> CUSTOM COMPONENTS >>>>>>>>>>>>>>>>>>>>>>

// define your custom component, where key is the ID of the component
// 'yourIdHere': textLabelComponent("{key}")

// and use it in the page definition
// customComponent("yourIdHere")

// we can also define replacements for the component, that means where we have
// '{key}' in the component, we can replace it with the value
// customComponent("yourIdHere", {
//   'key': 'Your replacement here',
// })

/*
// or we can name it also 'reusable' components
static Map<String, dynamic> customComponents = {
  // USAGE:
  // customComponent("buttonHello")
  'buttonHello': buttonComponent(
    textLabelComponent("Hello !{{mainColor}}"),
    [
      action("ActionShowDialogWithActions", {
        "title": textLabelComponent("Hello", "#000000"),
        "content": textLabelComponent("Hello World!", "#000000"),
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
  ),

  // USAGE: yes, it recursively replaces the values
  // customComponent("buttonHelloWithArgs", {
  //   'arg2': '!!!',
  // })
  'buttonHelloWithArgs': buttonComponent(
    textFormattedComponent("Hello {arg1}", {
      "arg1": ">{{someStoredKey;defaultValue}}"
    }, "#ffffff"),
    [
      action("ActionShowDialogWithActions", {
        "title": textLabelComponent("Hello", "#000000"),
        "content": textLabelComponent("Hello World!", "#000000"),
        "actions": [
          buttonComponent(
            textLabelComponent("OK {arg2}"),
            [
              action("ActionNavigationPop")
            ]
          ),
        ],
      }),
    ]
  ),
};
*/

class GlobalJsonData {
  static Map<String, JsonP> pages = pageDefinitions.data.map((key, value) =>
    MapEntry(key, JsonP(key, value))
  );

  static JsonSerializable customMetadata = const JsonSerializable({
    "layouts": {
      "GoodsReceipt": { // Příjemky
        "appList": [
          { "name": "name" },
          { "name": "createdAt" },
          { "name": "warehouse" },
          { "name": "status" },
          { "name": "description" },
        ],
      },
      // "GoodsIssue": { // Výdejky
      //   "list": [
      //     { "name": "name" },
      //     { "name": "createdAt" },
      //     { "name": "warehouse" },
      //     { "name": "createdAt" },
      //   ]
      // },
      "WarehouseTransfer": { // Skladové Přesuny
        "appList": [
          { "name": "name" },
          { "name": "status" },
          { "name": "createdAt" },
          { "name": "warehouseFrom" },
          { "name": "warehouseTo" },
        ]
      },
    },

    "i18n": {
      "en_US": {
        "Global": {
          "things": {
            "LogoutButtonTitle": "Odhlásit se",
          }
        },
      },
      "cs_CZ": {
        "Global": {
          "things": {
            "LogoutButtonTitle": "Odhlásit se",
          }
        },
        "GoodsReceipt": {
          "name": "Příjemka",
          "createdAt": "Vytvořeno",
          "warehouse": "Sklad",
          "status": "Stav",
          "description": "Popis",
        },
        "GoodsIssue": {
          "name": "Výdejka",
          "createdAt": "Vytvořeno",
          "warehouse": "Sklad",
          "status": "Stav",
          "description": "Popis",
        },
        "WarehouseTransfer": {
          "name": "Přesun",
          "status": "Stav",
          "createdAt": "Vytvořeno",
          "warehouseFrom": "Sklad odkud",
          "warehouseTo": "Sklad kam",
        },
      },
    },
  });

  static JsonSerializable customValues = const JsonSerializable({
    'mainColor': '#000000',
    'siteUrl': 'http://192.168.178.20:4004/',
  });

  static JsonSerializable customComponents = const JsonSerializable({});

  static JsonSerializable customVariables = const JsonSerializable({
    'initialPage': 'Login',
  });

  static JsonSerializable appSettings = const JsonSerializable({
    "initialPage": "Login",
  });

  static JsonSerializable pageDefinitions = JsonSerializable({
    "Login": {
      "settings": {
        "onLoggedInUser": [
          ABuilder.actionSetPage("MainMenu")
        ],
        "ignoreHistory": true,
        "appBar": CBuilder.appBarWithoutLeading("Login"),
      },
      "component": CBuilder.espoLoginForm([
        ABuilder.actionSetPage("MainMenu")
      ]).applyPaddingVH(0, 16)
    },
    "Project/create": {
      "entityType": "Project",
      "settings": {
        "appBar": CBuilder.appBar("Create Project"),
        // "drawer": "[fromTabList+logoutButton]",
        "drawer": CBuilder.drawer(
          CBuilder.safeArea(
            CBuilder.column([
              CBuilder.expanded(
                CBuilder.espoTabList(),
              ),
              CBuilder.logoutButton(),
            ]),
          )
        ),
      },
      "component": CBuilder.singleChildScrollView(
        CBuilder.detail([
          [ CBuilder.fieldLabelBold("name")   ],
          [ CBuilder.fieldNewEntity("name")   ],

          [ CBuilder.fieldLabelBold("status") ],
          [ CBuilder.fieldNewEntity("status") ],

          [ CBuilder.list(
            overrideEntityType: "Project",
            enableRefreshButton: true,
            divideByComponent: CBuilder.sizedBox(0, 16),
            itemComponent: CBuilder.detail([
              [
                CBuilder.fieldLabelBold("name"),
                CBuilder.field("name"),
              ],
              [
                CBuilder.fieldLabelBold("status"),
                CBuilder.field("status")   
              ]
            ])
          ) ],

          [
            CBuilder.button(
              CBuilder.textLabel("Espo Changes", "#ffffff"),
              [
                ABuilder.a(ActionEspoChangesBottomSheet.id)
              ]
            )
          ]
        ]).applyPaddingVH(0, 16),
      ),
    },
    "GoodsReceipt/detail": {
      "settings": {
        "appBar": CBuilder.appBar("Příjemka"),
        "drawer": CBuilder.drawer(
          CBuilder.safeArea(
            CBuilder.column([
              CBuilder.row([
                CBuilder.expanded(
                  CBuilder.textLabel("Příjemka - Výběr")
                )
              ]),

              CBuilder.sizedBox(0, 16),

              CBuilder.row([
                CBuilder.expanded(
                  CBuilder.button(
                    CBuilder.textLabel("Naskladnit", "#ffffff")
                      .applyPaddingVH(16, 0),
                    [ ABuilder.a(ActionSetEntityValue.id, {
                      'immediate': true,
                      'data': { 'status': 'Processing' }
                    }) ]
                  )
                )
              ]),

              CBuilder.sizedBox(0, 16),
              
              CBuilder.row([
                CBuilder.expanded(
                  CBuilder.button(
                    CBuilder.textLabel("Naskladnit s výhradou", "#ffffff")
                      .applyPaddingVH(16, 0),
                    [ ABuilder.a(ActionSetEntityValue.id, {
                      'immediate': true,
                      'data': { 'status': 'Draft' }
                    }) ]
                  )
                )
              ]),

              CBuilder.sizedBox(0, 16),
              
              CBuilder.row([
                CBuilder.expanded(
                  CBuilder.button(
                    CBuilder.textLabel("Jen uložit", "#ffffff")
                      .applyPaddingVH(16, 0),
                    [ ABuilder.a(ActionSetEntityValue.id, {
                      'immediate': true,
                      'data': { 'status': 'Draft' }
                    }) ]
                  )
                )
              ]),

              CBuilder.sizedBox(0, 16),
              
              CBuilder.row([
                CBuilder.expanded(
                  CBuilder.button(
                    CBuilder.textLabel("Hlavní Menu", "#ffffff")
                      .applyPaddingVH(16, 0),
                    [ ABuilder.a(ActionSetPage.id, {
                      "page": "MainMenu"
                    }) ]
                  )
                )
              ]),

              CBuilder.sizedBox(0, 16),
              
              CBuilder.row([
                CBuilder.expanded(
                  CBuilder.button(
                    CBuilder.textLabel("Zpět", "#ffffff")
                      .applyPaddingVH(16, 0),
                    [ ABuilder.a(ActionPageBack.id) ]
                  )
                )
              ]),

              CBuilder.sizedBox(0, 16),
              
              CBuilder.row([
                CBuilder.expanded(
                  CBuilder.button(
                    CBuilder.textLabel("Zavřít postranní menu", "#ffffff")
                      .applyPaddingVH(16, 0),
                    [ ABuilder.a(ActionCloseDrawer.id) ]
                  )
                )
              ]),

              CBuilder.sizedBox(0, 16),

            ], { "mainAxisAlignment": "end" }),
          ).applyPaddingVH(0, 16)
        ),
      },
      "component": CBuilder.safeArea(
        CBuilder.singleChildScrollView(
          CBuilder.detail([
            [ CBuilder.list(
              overrideEntityType: 'WarehouseItem',
              defaultFilters: [
                { "type": "in", "attribute": "id", "value": "@<<{{itemsIds}}" }
              ],
              defaultOrderBy: '',
              defaultOrderDirection: '',
              itemComponent: CBuilder.detail([
                [
                  CBuilder.fieldLabelBold("productName"),
                  CBuilder.field("productName")
                ],
                [
                  CBuilder.fieldLabelBold("productCode"),
                  CBuilder.field("productCode")
                ],
                [
                  CBuilder.fieldLabelBold("quantity"),
                  CBuilder.textLabel("<<{{expectedQuantity;0}} / <<{{quantity}}")
                ],
                [
                  CBuilder.fieldLabelBold("positionName"),
                  CBuilder.field("positionName")
                ],
                [
                  CBuilder.fieldLabelBold("serialNo"),
                  CBuilder.field("serialNo")
                ],
              ]),
              onItemTap: [
                ABuilder.a(ActionSetPageFromComponent.id, {
                  "pageId": "Product/detail",
                  "appBar": CBuilder.appBar("Příjemka - Detail Zboží"),
                  "component": CBuilder.safeArea(
                    CBuilder.singleChildScrollView(
                      CBuilder.detail([
                        [ CBuilder.fieldLabelBold("name") ],
                        [ CBuilder.field("name") ],
                        [ CBuilder.fieldLabelBold("Počet") ],
                        [ CBuilder.field("totalAvailableQuantity") ],
                        [ CBuilder.textLabel("<<{{id}}") ],
                        [ CBuilder.textLabel("(({{id}}") ],
                      ]).applyPaddingVH(0, 16)
                    ),
                  ),
                }),
              ],
            )],
          ]),
        ),
      ),
    },
    "GoodsReceipt/appList": {
      "settings": {
        "appBar": CBuilder.appBar("Příjemky"),
        "drawer": CBuilder.drawer(
          CBuilder.safeArea(
            CBuilder.column([
              CBuilder.row([
                CBuilder.expanded(
                  CBuilder.textLabel("Příjemky - Výběr")
                )
              ]),

              CBuilder.sizedBox(0, 16),

              CBuilder.row([
                CBuilder.expanded(
                  CBuilder.button(
                    CBuilder.textLabel("Vytvořit příjemku", "#ffffff")
                      .applyPaddingVH(16, 0),
                    [
                      ABuilder.a(ActionSetParentContext.id),
                      ABuilder.a(ActionSetPageFromComponent.id, {
                        "pageId": "GoodsReceipt/create",
                        "appBar": CBuilder.appBar("Vytvořit příjemku"),
                        "component": CBuilder.safeArea(
                          CBuilder.singleChildScrollView(
                            CBuilder.detail([
                              [ CBuilder.fieldLabelBold("name") ],
                              [ CBuilder.fieldNewEntity("name", "GoodsReceipt") ],
                              [ CBuilder.fieldLabelBold("warehouse") ],
                              [ CBuilder.fieldNewEntity("warehouse", "GoodsReceipt") ],
                              [ CBuilder.fieldLabelBold("parent") ],
                              [ CBuilder.fieldNewEntity("parent") ],
                              [ CBuilder.button(CBuilder.textLabel("Změny", "#ffffff"), [ ABuilder.a(ActionEspoChangesBottomSheet.id) ]) ],
                              [ CBuilder.button(CBuilder.textLabel("Vytvořit", "#ffffff"), [ ABuilder.a(ActionSyncEspoChanges.id) ]) ],
                              [ CBuilder.button(CBuilder.textLabel("Zpět", "#ffffff"), [ ABuilder.a(ActionPageBack.id) ]) ],
                            ]).applyPaddingVH(0, 16)
                          )
                        ),
                      }),
                      ABuilder.a(ActionUnSetParentContext.id),
                    ]
                  )
                )
              ]),

              CBuilder.sizedBox(0, 16),
              
              CBuilder.row([
                CBuilder.expanded(
                  CBuilder.button(
                    CBuilder.textLabel("Zavřít postranní menu", "#ffffff")
                      .applyPaddingVH(16, 0),
                    [ ABuilder.a(ActionCloseDrawer.id) ]
                  )
                )
              ]),

              CBuilder.sizedBox(0, 16),

            ], { "mainAxisAlignment": "end" }),
          ).applyPaddingVH(0, 16)
        ),
      },
      "component": CBuilder.safeArea(
        CBuilder.singleChildScrollView(
          CBuilder.detail([
            [ CBuilder.list(
              overrideEntityType: 'GoodsReceipt',
              itemComponent: CBuilder.detail([
                [
                  CBuilder.fieldLabelBold("name"),
                  CBuilder.field("name")
                ],
                [
                  CBuilder.fieldLabelBold("createdAt"),
                  CBuilder.field("createdAt")
                ],
                [
                  CBuilder.fieldLabelBold("warehouse"),
                  CBuilder.textLabel("warehouse")
                ],
                [
                  CBuilder.fieldLabelBold("status"),
                  CBuilder.field("status")
                ],
                [
                  CBuilder.fieldLabelBold("description"),
                  CBuilder.field("description")
                ],
              ]),
              divideByComponent: CBuilder.sizedBox(0, 16),
              onItemTap: [
                ABuilder.actionSetPage("GoodsReceipt/detail")
              ],
            )],
          ]),
        ),
      ),
    },
    "MainMenu": {
      "settings": {
        // "appBar": CBuilder.appBarWithoutLeading("Hlavní Menu"),
        // "drawer": CBuilder.custom("superDrawer"),
      },
      "component": CBuilder.singleChildScrollView(
        CBuilder.column([
          CBuilder.sizedBox(0, 64),

          CBuilder.row([
            CBuilder.expanded(
              CBuilder.imageUrl("<url>")
            )
          ]),
          CBuilder.row([
            CBuilder.expanded(
              CBuilder.imageAsset("assets/images/app.png", { "height": 16.0 })
                .applyPaddingLTRB(0, 0, 0, 16)
            )
          ]),
          CBuilder.row([
            CBuilder.expanded(
              CBuilder.button(
                CBuilder.textLabel("Příjemky", "#ffffff")
                  .applyPaddingVH(16, 0),
                [ ABuilder.actionSetPage('GoodsReceipt/appList') ],
              ),
            ),
            CBuilder.sizedBox(16),
            CBuilder.expanded(
              CBuilder.button(
                CBuilder.textLabel("Výdejky", "#ffffff")
                  .applyPaddingVH(16, 0),
                [
                  ABuilder.a(ActionSetPageFromLayout.id, {
                    "entityType": "GoodsIssue",
                    "layoutName": "list",
                    "appBar": CBuilder.appBar("Výdejky"),
                    "drawer": "[fromTabList+logoutButton]",
                    "listInfo": {
                      "onItemTap": [
                        ABuilder.a(ActionSetPageFromLayout.id, {
                          "entityType": "GoodsIssue",
                          "layoutName": "detail",
                          "appBar": CBuilder.appBar("Výdejka"),
                          "drawer": "[fromTabList+logoutButton]",
                        })
                      ],
                    }
                  }),
                ]
              ),
            ),
          ]),
          CBuilder.sizedBox(0, 16),
          CBuilder.row([
            CBuilder.expanded(
              CBuilder.button(
                CBuilder.textLabel("Skladové Přesuny", "#ffffff")
                  .applyPaddingVH(16, 0),
                [
                  ABuilder.a(ActionSetPageFromLayout.id, {
                    "entityType": "WarehouseTransfer",
                    "layoutName": "appList",
                    "appBar": CBuilder.appBar("Skladové Přesuny"),
                    "drawer": "[fromTabList+logoutButton]",
                    "listInfo": {
                      "onItemTap": [
                        ABuilder.a(ActionSetPageFromLayout.id, {
                          "entityType": "WarehouseTransfer",
                          "layoutName": "detail",
                          "appBar": CBuilder.appBar("Skladové Přesuny"),
                          "drawer": "[fromTabList+logoutButton]",
                        })
                      ],
                    }
                  }),
                ]
              ),
            ),
          ]),
          CBuilder.sizedBox(0, 16),
          CBuilder.row([
            CBuilder.expanded(
              CBuilder.button(
                CBuilder.textLabel("Produkty", "#ffffff")
                  .applyPaddingVH(16, 0),
                [
                  ABuilder.a(ActionSetPageFromLayout.id, {
                    "entityType": "Product",
                    "layoutName": "list",
                    "appBar": CBuilder.appBar("Produkty"),
                    "drawer": "[fromTabList+logoutButton]",
                    "listInfo": {
                      "onItemTap": [
                        ABuilder.a(ActionSetPageFromLayout.id, {
                          "entityType": "Product",
                          "layoutName": "detail",
                          "appBar": CBuilder.appBar("Produkty"),
                          "drawer": "[fromTabList+logoutButton]",
                        })
                      ],
                    }
                  }),
                ]
              ),
            ),
          ]),
          CBuilder.sizedBox(0, 16),
          CBuilder.row([
            CBuilder.expanded(
              CBuilder.button(
                CBuilder.textLabel("Nastavení", "#ffffff")
                  .applyPaddingVH(16, 0),
                [
                  ABuilder.a(ActionSetPageFromComponent.id, {
                    "pageId": "Settings",
                    "appBar": CBuilder.appBar("Nastavení"),
                    "drawer": "[fromTabList+logoutButton]",
                    "component": CBuilder.stack([
                      CBuilder.positioned(
                        CBuilder.safeArea(
                          CBuilder.container(
                            CBuilder.row([
                              CBuilder.button(
                                CBuilder.textLabel("Zpět", "#ffffff")
                                  .applyPaddingVH(16, 0),
                                [
                                  ABuilder.a(ActionPageBack.id)
                                ]
                              ),
                            ], { "mainAxisAlignment": "spaceEvenly" }),
                            { "padding": { "all": 16.0 }, "color": "#f4f4f4"}
                          ),
                        ),
                        { "bottom": 0.0, "left": 0.0, "right": 0.0 }
                      ),
                    ])
                  }),
                ]
              ),
            ),
          ]),
          CBuilder.sizedBox(0, 16),
          CBuilder.row([
            CBuilder.expanded(
              CBuilder.button(
                CBuilder.textLabel("Odhlásit se", "#ffffff")
                  .applyPaddingVH(16, 0),
                [
                  ABuilder.a(ActionShowDialogWithActions.id, {
                    "title": CBuilder.textLabel("Odhlášení"),
                    "content": CBuilder.textLabel("Opravdu se chcete odhlásit?"),
                    "actions": [
                      CBuilder.button(
                        CBuilder.textLabel("Ano", "#ffffff"),
                        [
                          ABuilder.a(ActionNavigationPop.id),
                          ABuilder.a(ActionLogout.id),
                          ABuilder.a(ActionSetPage.id, {
                            "page": ">>{{initialPage;Login}}"
                          })
                        ]
                      ),
                      CBuilder.button(
                        CBuilder.textLabel("Ne", "#ffffff"),
                        [
                          ABuilder.a(ActionNavigationPop.id)
                        ]
                      ),
                    ]
                  })
                ]
              ),
            ),
          ]),
          // CBuilder.sizedBox(0, 16),
          // CBuilder.row([
          //   CBuilder.expanded(
          //     CBuilder.button(
          //       CBuilder.textLabel("Project/create", "#ffffff")
          //         .applyPaddingVH(16, 0),
          //       [
          //         ABuilder.actionSetPage("Project/create"),
          //       ]
          //     ),
          //   ),
          // ])
        ]).applyPaddingVH(0, 16),
      ),
    },
  });
}