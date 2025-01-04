class AndromedaAppTemplates {
  static String get helloWorld => """
App {
  @config {
    theme: @{
      primary: "#ff0000"
      secondary: "#ff0000"
    }
  }

  @pages {
    InitialPage {
      @render {
        Text {
          @prop { text: "Hello, World!" }
        }
      }
    }
  }
}
""".trim();
}