module.exports = ({ github, context }) => {
  const tag = context.ref.substring(11, 13)
  console.log("tag: " + tag)
  try {
    await github.git.deleteRef({
      owner: context.repo.owner,
      repo: context.repo.repo,
      ref: "tags/" + tag
    })
  } catch (e) {
    console.log("The tag '" + tag + "' doesn't exist yet: " + e)
  }
  await github.git.createRef({
    owner: context.repo.owner,
    repo: context.repo.repo,
    ref: "refs/tags/" + tag,
    sha: context.sha
  })
}
