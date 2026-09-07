// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import { Runtime } from '@herb-tools/client'

Runtime.start({ state: { debounce: 150 } })

window.HerbRuntime = Runtime
