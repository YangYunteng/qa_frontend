<template>
  <div class="container">
    <img class="head"
         src="https://img.zcool.cn/community/01b0645a112c1ea80121985c0ea3d0.jpg@1280w_1l_2o_100sh.jpg" alt="user"/>
    <div class="content">
      <div class="text" style="word-break: break-all;">
        {{content}}
      </div>
    </div>
  </div>
</template>

<script>

export default {
  name: "User",
  props: ['id', 'content']
}
</script>

<style scoped lang="scss">
.container {
  display: flex;
  padding: 10px 15px;
  margin-right: 60px;
  flex-direction: row-reverse;

  .head {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    border: 1px solid #eee;
  }

  .content {
    margin-right: 10px;
    margin-top: 10px;

    .text {
      background-color: #eee;
      border-bottom-left-radius: 10px;
      padding: 5px 5px;
      font-size: 14px;
      color: #000;
    }

    .img {
      width: 100px;
      border-bottom-right-radius: 10px;
      border-top-right-radius: 10px;
      border-bottom-left-radius: 10px;
    }
  }

}
</style>
