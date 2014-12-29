class Category < ActiveRecord::Base
  belongs_to :parent, class_name: "Category"
  belongs_to :user
  has_many :children, class_name: "Category", foreign_key: "parent_id"

  validates :name, presence: true, length: {minimum: 3, maximum: 30}, uniqueness: {scope: :parent_id}
  validates :slug, presence: true, length: {maximum: 30}, format: {with: /\A[\w][\w-]+\z/}, uniqueness: {scope: :parent_id}

  after_destroy :destory_children

  def parent_name
    parentname = "-" * 3
    parentname = self.parent.name unless self.parent.nil?
    parentname
  end

  def user_name
    username = "-" * 3
    username = self.user.email unless self.user.nil?
    username
  end

  def ancestors
    @ancesters = []
    current = self
    until current.nil? || current.name.empty? do
      @ancesters.insert(0, current)
      current = current.parent
    end
    @ancesters
  end

  private
  def destory_children
    @children = self.children
    for child in @children
      child.destroy
    end
  end
end
