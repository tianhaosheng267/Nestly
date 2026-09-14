


import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "section", "mainImage", "star"]
  show() {
    this.previewTarget.innerHTML = ""
    this.sectionTarget.style.display = "none"

    const files = Array.from(this.inputTarget.files)

    if (files.length > 10) {
      alert("You can upload a maximum of 10 images.")
      this.inputTarget.value = ""
      return
    }
    if (files.length === 0) return
    this.sectionTarget.style.display = "block"

    files.forEach((file, index) => {
      if (!file.type.startsWith("image/")) return
      const reader = new FileReader()
      reader.onload = (event) => {
        const previewCard = document.createElement("div")
        const image = document.createElement("img")
        const fileName = document.createElement("p")
        const removeButton = document.createElement("button")
        const starButton = document.createElement("button")

        previewCard.className = "property-image-preview-card"
        image.src = event.target.result
        image.alt = `Preview of ${file.name}`
        image.className = "property-image-preview"
        fileName.textContent = file.name
        fileName.className = "property-image-preview-name"

        removeButton.type = "button"
        removeButton.innerHTML = "&times;"
        removeButton.className = "property-image-remove"

        starButton.type = "button"
        starButton.innerHTML = this.mainImageTarget.value === `new:${index}` ? "★" : "☆"
        starButton.className = "property-image-star"
        starButton.dataset.imagePreviewTarget = "star"
        starButton.dataset.action = "click->image-preview#selectNew"
        starButton.dataset.imageIndex = index
        starButton.title = this.mainImageTarget.value === `new:${index}` ? "Featured photo" : "Set as featured photo"

        if (this.mainImageTarget.value === `new:${index}`) {
          starButton.classList.add("property-image-star-selected")
          this.addFeaturedLabel(previewCard)
        }

        removeButton.onclick = () => {
          const dataTransfer = new DataTransfer()

          files.forEach((currentFile, currentIndex) => {
            if (currentIndex !== index) {
              dataTransfer.items.add(currentFile)
            }
          })
          this.inputTarget.files = dataTransfer.files

          const selectedIndex = Number(this.mainImageTarget.value.replace("new:", ""))
          if (this.mainImageTarget.value === `new:${index}`) {
            this.mainImageTarget.value = ""
          } else if (this.mainImageTarget.value.startsWith("new:") && selectedIndex > index) {
            this.mainImageTarget.value = `new:${selectedIndex - 1}`
          }
          this.show()
        }
        previewCard.appendChild(removeButton)
        previewCard.appendChild(starButton)
        previewCard.appendChild(image)
        previewCard.appendChild(fileName)
        this.previewTarget.appendChild(previewCard)
      }
      reader.readAsDataURL(file)
    })
  }

  selectNew(event) {
    this.mainImageTarget.value = `new:${event.currentTarget.dataset.imageIndex}`
    this.selectStar(event.currentTarget)
  }

  selectExisting(event) {
    this.mainImageTarget.value = `existing:${event.currentTarget.dataset.imageId}`
    this.selectStar(event.currentTarget)
  }

  selectStar(selectedStar) {
    this.starTargets.forEach((star) => {
      star.innerHTML = "☆"
      star.title = "Set as featured photo"
      star.classList.remove("property-image-star-selected")
    })
    this.element.querySelectorAll(".property-image-featured").forEach((label) => label.remove())

    selectedStar.innerHTML = "★"
    selectedStar.title = "Featured photo"
    selectedStar.classList.add("property-image-star-selected")
    this.addFeaturedLabel(selectedStar.parentElement)
  }

  addFeaturedLabel(card) {
    const featuredLabel = document.createElement("span")
    featuredLabel.textContent = "Featured"
    featuredLabel.className = "property-image-featured"
    card.appendChild(featuredLabel)
  }
}