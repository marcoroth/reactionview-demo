// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import { HerbRuntime } from '@herb-tools/client'
import { FetchRequest } from '@rails/request.js'

const transport = async (request, signal) => {
  const fetchRequest = new FetchRequest(request.method, request.url, {
    body: request.body,
    headers: request.headers,
    query: { format: 'slots' },
    signal,
  })

  const response = await fetchRequest.perform()

  if (!response.ok) throw new Error(`Herb mutation failed with ${response.statusCode}`)

  return response.json
}

HerbRuntime.start({ state: { debounce: 150, persist: "known" }, mutations: { transport } })

window.HerbRuntime = HerbRuntime
