module ApplicationHelper

  def center_div_classes
    "w-full max-w-prose mx-auto lg:mx-[10%] xl:mx-[15%]"
  end

  def img_classes
    "rounded w-full object-cover drop-shadow max-h-[40vh]"
  end

  def zoomable_image_tag(container, image, classes)
    image = container.find_part(image) unless image.is_a? Spina::Parts::Image

    img_tag = container.content.image_tag image, { loader: { page: nil } }, { role: "button", class: classes, data: { controller: "image", action: "click->image#openZoom", id: image.object_id } }
    img_zoom = render('default/shared/image_zoom', image: image)
    return img_tag + img_zoom
  end
end
