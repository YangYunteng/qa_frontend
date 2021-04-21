<template>
    <v-app-bar fixed>
      <v-toolbar-title>
        <v-img max-width="400" height="44" src="../assets/logo.png"></v-img>
      </v-toolbar-title>
      <v-toolbar-items>
        <v-menu
          v-for="(n, index) in menu"
          :key="index"
          open-on-hover
          offset-y
        >
          <template v-slot:activator="{ on, attrs }">
            <v-btn text v-bind="attrs" v-on="on"> {{ n.title }}</v-btn>
          </template>

          <v-list v-if="n.submenu">
            <v-list-item
              v-for="(item, index) in n.submenu"
              :key="index"
              @click="() => {}"
            >
              <v-list-item-title> {{ item.itemTitle }}</v-list-item-title>
            </v-list-item>
          </v-list>
        </v-menu>
      </v-toolbar-items>
    </v-app-bar>
</template>

<script>
export default {
  name: "UserHomeNavigation",
  data(){
    return {
      menu: [
        { index: "1", title: "首页" },
        {
          index: "2",
          title: "博客",
          submenu: [{ itemIndex: "2-1", itemTitle: "消息" }],
        },
        {
          index: "3",
          title: "程序员学院",
        },
        {
          index: "4",
          title: "下载",
        },
        {
          index: "5",
          title: "论坛",
        },
        {
          index: "6",
          title: "问答",
        },
        {
          index: "7",
          title: "代码",
        },
        {
          index: "8",
          title: "直播",
        },
        {
          index: "9",
          title: "能力认证",
        },
        {
          index: "10",
          title: "高校",
        },
      ],

    }
  }
}
</script>

<style scoped>

</style>
