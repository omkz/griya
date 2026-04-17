import { Controller } from "@hotwired/stimulus"
import { DirectUpload } from "@rails/activestorage"

export default class extends Controller {
    static targets = ["input", "preview"]

    handleFiles(event) {
        const files = Array.from(event.target.files)
        files.forEach(file => this.uploadFile(file))

        // Clear the input so the same files can be selected again if needed
        // event.target.value = null
    }

    uploadFile(file) {
        const tempId = Math.random().toString(36).substring(2, 9)
        this.createPreviewElement(file, tempId)

        const url = this.inputTarget.getAttribute("data-direct-upload-url")

        // Create delegate to handle progress for THIS specific file
        const delegate = {
            directUploadWillStoreFileWithXHR: (request) => {
                request.upload.addEventListener("progress", event => {
                    const progress = (event.loaded / event.total) * 100
                    const progressElement = document.getElementById(`progress-${tempId}`)
                    if (progressElement) progressElement.style.width = `${progress}%`
                })
            }
        }

        const upload = new DirectUpload(file, url, delegate)

        upload.create((error, blob) => {
            if (error) {
                this.handleError(tempId, error)
            } else {
                this.handleSuccess(tempId, blob)
            }
        })
    }

    createPreviewElement(file, tempId) {
        const reader = new FileReader()
        reader.onload = (e) => {
            const html = `
        <div class="aspect-square rounded-2xl overflow-hidden border-2 border-blue-400 shadow-md relative animate-pulse" id="preview-${tempId}">
          <img src="${e.target.result}" class="w-full h-full object-cover">
          <div class="absolute inset-x-2 bottom-2 bg-black/60 rounded-full h-1.5 overflow-hidden">
            <div class="bg-blue-500 h-full w-0 transition-all duration-300" id="progress-${tempId}"></div>
          </div>
          <div class="absolute top-2 right-2 flex gap-1">
            <span class="upload-badge bg-blue-600 text-white text-[8px] font-black px-2 py-1 rounded uppercase shadow-lg">Uploading</span>
            <button type="button" class="bg-white/20 hover:bg-red-500 text-white rounded px-1 transition" onclick="this.closest('#preview-${tempId}').remove()">✕</button>
          </div>
        </div>
      `
            this.previewTarget.insertAdjacentHTML("beforeend", html)
        }
        reader.readAsDataURL(file)
    }

    handleError(tempId, error) {
        const container = document.getElementById(`preview-${tempId}`)
        if (container) {
            container.classList.add("border-red-500")
            container.querySelector('.upload-badge').innerHTML = "Error"
            container.querySelector('.upload-badge').className = "upload-badge bg-red-600 text-white text-[8px] font-black px-2 py-1 rounded uppercase"
            console.error(error)
        }
    }

    handleSuccess(tempId, blob) {
        const container = document.getElementById(`preview-${tempId}`)
        if (container) {
            container.classList.remove("animate-pulse", "border-blue-400")
            container.classList.add("border-green-400")
            container.querySelector('.upload-badge').innerHTML = "Ready"
            container.querySelector('.upload-badge').className = "upload-badge bg-green-500 text-white text-[8px] font-black px-2 py-1 rounded uppercase"

            const hiddenField = document.createElement("input")
            hiddenField.type = "hidden"
            hiddenField.name = "property[images][]"
            hiddenField.value = blob.signed_id
            container.appendChild(hiddenField)
        }
    }
}
