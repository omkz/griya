import { Controller } from "@hotwired/stimulus"
import { DirectUpload } from "@rails/activestorage"

export default class extends Controller {
    static targets = ["input", "preview"]

    async handleFiles(event) {
        const files = Array.from(event.target.files)

        // Reset the input so it can be used again for the same files
        event.target.value = null

        for (const file of files) {
            if (!file.type.startsWith('image/')) {
                this.uploadFile(file)
                continue
            }

            // Automagically compress images before upload for premium UX
            try {
                const compressedFile = await this.compressImage(file)
                this.uploadFile(compressedFile)
            } catch (error) {
                console.error("Compression failed, uploading original:", error)
                this.uploadFile(file)
            }
        }
    }

    // Client-side image compression logic
    compressImage(file) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader()
            reader.readAsDataURL(file)
            reader.onload = (event) => {
                const img = new Image()
                img.src = event.target.result
                img.onload = () => {
                    const canvas = document.createElement('canvas')
                    const MAX_WIDTH = 2500 // Maximum resolution for real estate photos
                    const MAX_HEIGHT = 2000
                    let width = img.width
                    let height = img.height

                    // Calculate new dimensions maintainting aspect ratio
                    if (width > height) {
                        if (width > MAX_WIDTH) {
                            height *= MAX_WIDTH / width
                            width = MAX_WIDTH
                        }
                    } else {
                        if (height > MAX_HEIGHT) {
                            width *= MAX_HEIGHT / height
                            height = MAX_HEIGHT
                        }
                    }

                    canvas.width = width
                    canvas.height = height
                    const ctx = canvas.getContext('2d')

                    // High quality interpolation
                    ctx.drawImage(img, 0, 0, width, height)

                    canvas.toBlob((blob) => {
                        if (!blob) {
                            reject(new Error("Canvas toBlob failed"))
                            return
                        }
                        // Create a new File object from the compressed blob
                        const compressedFile = new File([blob], file.name, {
                            type: 'image/jpeg',
                            lastModified: Date.now()
                        })
                        resolve(compressedFile)
                    }, 'image/jpeg', 0.85) // 85% quality is the sweet spot
                }
                img.onerror = reject
            }
            reader.onerror = reject
        })
    }

    uploadFile(file) {
        const tempId = Math.random().toString(36).substring(2, 9)
        this.createPreviewElement(file, tempId)

        const url = this.inputTarget.getAttribute("data-direct-upload-url")

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
            const badge = container.querySelector('.upload-badge')
            if (badge) {
                badge.innerHTML = "Error"
                badge.className = "upload-badge bg-red-600 text-white text-[8px] font-black px-2 py-1 rounded uppercase"
            }
            console.error(error)
        }
    }

    handleSuccess(tempId, blob) {
        const container = document.getElementById(`preview-${tempId}`)
        if (container) {
            container.classList.remove("animate-pulse", "border-blue-400")
            container.classList.add("border-green-400")
            const badge = container.querySelector('.upload-badge')
            if (badge) {
                badge.innerHTML = "Ready"
                badge.className = "upload-badge bg-green-500 text-white text-[8px] font-black px-2 py-1 rounded uppercase"
            }

            const hiddenField = document.createElement("input")
            hiddenField.type = "hidden"
            hiddenField.name = "property[images][]"
            hiddenField.value = blob.signed_id
            container.appendChild(hiddenField)
        }
    }
}
