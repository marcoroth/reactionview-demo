import { Controller } from "@hotwired/stimulus"
import { toast } from "moly-ui"

export default class extends Controller {
  plain() {
    toast("Event has been created")
  }

  success() {
    toast.success("Changes saved")
  }

  error() {
    toast.error("Could not reach the server")
  }

  warning() {
    toast.warning("Your trial ends in three days")
  }

  info() {
    toast.info("A new version is available")
  }

  describe() {
    toast("Deployed to production", { description: "Monday, January 3rd at 6:00pm" })
  }

  undo() {
    toast("Album archived", {
      action: { label: "Undo", onClick: () => toast.success("Album restored") },
    })
  }

  promise() {
    toast.promise(this.#upload(), {
      loading: "Uploading the artwork",
      success: (name) => `Uploaded ${name}`,
      error: "The upload failed",
    })
  }

  sticky() {
    toast.loading("Rendering, this one stays until you close it", { closeButton: true })
  }

  many() {
    ;["First", "Second", "Third", "Fourth", "Fifth"].forEach((title, index) => {
      window.setTimeout(() => toast(title), index * 120)
    })
  }

  dismiss() {
    toast.dismiss()
  }

  #upload() {
    return new Promise((resolve, reject) => {
      window.setTimeout(() => (Math.random() > 0.25 ? resolve("cover.png") : reject(new Error("network"))), 1400)
    })
  }
}
