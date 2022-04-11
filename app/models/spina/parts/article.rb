module Spina
  module Parts
    class Article < Base
      attr_json :article_id, :integer

      def content
        Spina::Page.where(id: article_id).live.first
      end
    end
  end
end
