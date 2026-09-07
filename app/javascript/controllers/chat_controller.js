import { Controller } from "@hotwired/stimulus"
import { useState } from "@herb-tools/client/stimulus"
import { stateFor, slotsRequest } from "@herb-tools/client"
import { post } from "@rails/request.js"

export default class extends Controller {
  static targets = ["input", "server"]

  connect() {
    useState(this)
  }

  retry(event) {
    const row = event.currentTarget.closest("[data-message-id]")

    if (row && stateFor(row).get("body_draft") !== null) return this.save(event)

    this.outbox.retry(event.target)
  }

  discard(event) {
    this.outbox.discard(event.target)
  }

  async save(event) {
    const row = event.currentTarget.closest("[data-message-id]")
    const id = row.dataset.messageId
    const state = stateFor(row)
    const body = state.get("body_draft")
    const scope = state.scope

    state.set({ editing: false, pending: true, failed: false })

    const slot = scope?.item
      ? this.slots.slotInItem(scope.region.file, "messages", scope.item.key, "body", scope.region.occurrence)
      : null

    if (slot) this.slots.setText(slot, body)

    let payload

    try {
      payload = await slotsRequest(`/chat/messages/${id}`, { method: "PATCH", body: { body } })
    } catch {
      state.set({ pending: false, failed: true })

      return
    }

    this.slots.apply(payload, { items: "merge" })

    state.set({ pending: false, failed: false })
  }

  async destroy(event) {
    const row = event.currentTarget.closest("[data-message-id]")

    stateFor(row).set({ confirming: false })

    await this.#remove(row)
  }

  rowClicked(event) {
    const row = event.currentTarget

    if (stateFor(row).get("selecting") !== true) return
    if (event.target.closest("button, a, input, textarea, select, label")) return

    stateFor(row).toggle("selected")
  }

  async toggleStar(event) {
    const row = event.currentTarget.closest("[data-message-id]")
    const state = stateFor(row)

    state.toggle("starred")

    try {
      await slotsRequest(`/chat/messages/${row.dataset.messageId}`, { method: "PATCH", body: { starred: state.get("starred") } })
    } catch {
      state.toggle("starred")
    }
  }

  selectAll() {
    this.#setSelection(true)
  }

  deselectAll() {
    this.#setSelection(false)
  }

  #setSelection(value) {
    for (const row of this.element.querySelectorAll("[data-message-id]")) {
      stateFor(row).set({ selected: value })
    }
  }

  async destroySelected() {
    this.state.set({ confirming_bulk: false, selecting: false })

    const targets = [...this.element.querySelectorAll("[data-message-id]")]
      .filter((row) => stateFor(row).get("selected") === true)
      .map((row) => ({ id: row.dataset.messageId, scope: stateFor(row).scope }))
      .filter((target) => target.scope?.item)

    if (targets.length === 0) return

    const region = targets[0].scope.region
    const collection = this.slots.slot(region.file, "messages", region.occurrence)

    if (!collection) return

    const { token } = this.slots.transaction(() => {
      for (const target of targets) this.slots.removeItem(collection, target.scope.item.key)
    })

    const results = await Promise.allSettled(targets.map((target) => slotsRequest(`/chat/messages/${target.id}`, { method: "DELETE" })))

    if (results.some((result) => result.status === "rejected") && token !== null) this.slots.revert(token)
  }

  async #remove(row) {
    const state = stateFor(row)
    const scope = state.scope
    const collection = scope ? this.slots.slot(scope.region.file, "messages", scope.region.occurrence) : null

    if (!collection || !scope?.item) return

    const { token } = this.slots.transaction(() => this.slots.removeItem(collection, scope.item.key))

    try {
      await slotsRequest(`/chat/messages/${row.dataset.messageId}`, { method: "DELETE" })
    } catch {
      if (token !== null) this.slots.revert(token)
    }
  }

  async toggleServer() {
    const response = await post("/chat/refuse", { responseKind: "json" })
    const { refusing } = await response.json

    this.serverTarget.textContent = refusing ? "Revive the server" : "Kill the server"
  }
}
