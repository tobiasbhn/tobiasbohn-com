module Spina
  module Parts
    class Project < Base
      attr_json :project_id, :integer

      def content
        Spina::Page.where(id: project_id).live.first
      end

      def present?
        project_id.present?
      end
    end
  end
end
