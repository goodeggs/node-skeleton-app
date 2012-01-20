# Note, these helpers functions are compiled into the template as a string, so behavior may not be what you expect.
# For instance, any properties in scope (eg. private methods) during the definition of these helper methods will
# not exist in the template.

module.exports = helpers =
  # embed json data on the page assigned to the given key (eg. window.settings)
  embed: (obj) ->
    indent = if @settings.env == 'production' then 0 else 1
    script {type: 'text/javascript'}, ("#{key} = #{JSON.stringify(value, null, indent)};" for key, value of obj).join('\n')

  # return an obj trimmed to the given keys - the keys must exist
  only: (obj, keys...) ->
    result = {}
    for key in keys
      result[key] = obj[key]
      throw new Error('trying to embed a missing key') unless result[key]?
    result

  # Allows the main template to stored named content for use in the layout.
  content: (name, contentF) ->
    this._contents ?= {}
    if contentF
      this._contents[name] = yield contentF.bind(@)
    else
      text this._contents[name] or "<!-- no content for '#{name}' -->"

