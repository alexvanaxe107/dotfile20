self: super: {
  basic = super.buildEnv {
    name = "basic";
    paths = [
      self.steam
    ];
  };
}
