module.exports = async ({ github, context }) => {
  const tag = context.ref.substring(10, 12)
  console.log("tag: " + tag)
  try {
    await github.rest.git.deleteRef({
      owner: context.repo.owner,
      repo: context.repo.repo,
      ref: "tags/" + tag
    })
  } catch (e) {
    console.log("The tag '" + tag + "' doesn't exist yet: " + e)
  }
  await github.rest.git.createRef({
    owner: context.repo.owner,
    repo: context.repo.repo,
    ref: "refs/tags/" + tag,
    sha: context.sha
  })
}
