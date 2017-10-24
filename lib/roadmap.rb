module Roadmap
  def get_roadmap(roadmap_id)
    response = get_response("/roadmaps/"+roadmap_id)
    JSON.parse(response.body)
  end
  
  def get_checkpoint(checkpoint_id)
    response = get_response("/checkpoints/"+checkpoint_id)
    JSON.parse(response.body)
  end
end