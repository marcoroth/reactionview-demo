// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import { Runtime } from "reactionview"
import * as Moly from "moly-ui"

const runtime = Runtime.start()

Moly.install(runtime, { drawer: { themeColor: true }, toaster: { closeButton: true } })
